require "net/http"
require "uri"
require "json"
require "openssl"

class SommelierController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:recommend], raise: false

  def index
    return recommend if params[:query].present?

    @storages = current_user.storages.includes(:wines)
    @active_wines = current_user.wines.where(consumed_at: nil).where.not(storage_id: nil)
    @total_bottles = @active_wines.count
    @storages_summary = @storages.map do |st|
      {
        id: st.id,
        name: st.name,
        count: st.wines.where(consumed_at: nil).count
      }
    end
  end

  def recommend
    query = params[:query].to_s.strip
    locale = (params[:locale].presence || cookies[:cavin_locale].presence || "fr").to_s.downcase
    if query.blank?
      render json: { error: "Veuillez décrire votre plat ou votre occasion." }, status: :bad_request
      return
    end

    active_wines = current_user.wines.where(consumed_at: nil).where.not(storage_id: nil).includes(:storage).map do |w|
      {
        id: w.id,
        name: w.name,
        wine_type: w.wine_type,
        region: w.region,
        price: w.price.to_f,
        size: w.respond_to?(:size) && w.size.present? ? w.size : "75cl",
        storage_id: w.storage_id,
        storage_name: w.storage&.name || "Cave",
        row_position: w.row_position,
        col_position: w.col_position
      }
    end

    if active_wines.empty?
      render json: { error: "Vous n'avez aucune bouteille en stock actuellement dans vos caves." }, status: :bad_request
      return
    end

    api_key = ENV["GEMINI_API_KEY"].to_s.strip
    if api_key.blank?
      render json: { error: "Clé GEMINI_API_KEY manquante. Ajoutez GEMINI_API_KEY=... dans votre fichier .env puis redémarrez rails server." }, status: :internal_server_error
      return
    end

    lang_directive = case locale
                     when "it"
                       "Rispondi ESCLUSIVAMENTE in italiano, con il tono caloroso, preciso e raffinato di un Capo Sommelier italiano."
                     when "en"
                       "Respond EXCLUSIVELY in English, with the warm, precise, and refined tone of a Master Sommelier."
                     else
                       "Réponds EXCLUSIVEMENT en français, avec le ton chaleureux, précis et raffiné d'un Chef Sommelier français."
                     end

    payload = {
      systemInstruction: {
        parts: [
          {
            text: "Tu es le Chef Sommelier personnel de l'application Cavin. Ta mission est de recommander 1 à 3 bouteilles UNIQUEMENT parmi la liste des bouteilles présentes dans l'inventaire fourni (utilise exactement leur 'id' comme 'wine_id'). Ne propose JAMAIS un vin qui n'est pas dans l'inventaire. #{lang_directive} Pour chaque bouteille recommandée, explique pourquoi elle s'accorde parfaitement avec le plat ou l'occasion, son rapport avec le budget ou le prestige de l'événement, et donne un conseil précis de service (température idéale, carafage éventuel)."
          }
        ]
      },
      contents: [
        {
          role: "user",
          parts: [
            {
              text: "Demande du client (occasion ou repas) : \"#{query}\"\n\nVoici l'inventaire exact des bouteilles actuellement disponibles dans les caves de l'utilisateur :\n#{JSON.pretty_generate(active_wines)}"
            }
          ]
        }
      ],
      generationConfig: {
        responseMimeType: "application/json",
        responseSchema: {
          type: "OBJECT",
          properties: {
            sommelier_intro: { type: "STRING" },
            recommendations: {
              type: "ARRAY",
              items: {
                type: "OBJECT",
                properties: {
                  wine_id: { type: "INTEGER" },
                  pairing_reason: { type: "STRING" },
                  serving_tip: { type: "STRING" }
                },
                required: ["wine_id", "pairing_reason", "serving_tip"]
              }
            }
          },
          required: ["sommelier_intro", "recommendations"]
        }
      }
    }

    response_text = nil
    last_api_error = nil

    ["gemini-2.5-flash", "gemini-2.0-flash"].each do |model_name|
      uri = URI("https://generativelanguage.googleapis.com/v1beta/models/#{model_name}:generateContent?key=#{api_key}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.read_timeout = 25

      req = Net::HTTP::Post.new(uri)
      req["Content-Type"] = "application/json"
      req.body = payload.to_json

      res = http.request(req)
      body_json = JSON.parse(res.body) rescue {}
      if res.is_a?(Net::HTTPSuccess)
        text = body_json.dig("candidates", 0, "content", "parts", 0, "text")
        if text.present?
          response_text = text
          break
        end
      else
        last_api_error = body_json.dig("error", "message") || "HTTP #{res.code}"
      end
    end

    if response_text.blank?
      render json: { error: "Erreur API Gemini : #{last_api_error || 'Service indisponible'}" }, status: :service_unavailable
      return
    end

    parsed = JSON.parse(response_text)
    raw_recs = parsed["recommendations"].is_a?(Array) ? parsed["recommendations"] : []

    enriched = raw_recs.filter_map do |rec|
      bottle = active_wines.find { |w| w[:id] == rec["wine_id"].to_i }
      next unless bottle

      {
        wine_id: bottle[:id],
        wine_name: bottle[:name],
        wine_type: bottle[:wine_type],
        region: bottle[:region],
        price: bottle[:price],
        storage_id: bottle[:storage_id],
        storage_name: bottle[:storage_name],
        row_position: bottle[:row_position],
        col_position: bottle[:col_position],
        pairing_reason: rec["pairing_reason"],
        serving_tip: rec["serving_tip"]
      }
    end

    render json: {
      sommelier_intro: parsed["sommelier_intro"] || "Voici ma sélection issue de vos caves :",
      recommendations: enriched
    }
  rescue StandardError => e
    Rails.logger.error("Sommelier IA error: #{e.message}")
    render json: { error: "Erreur Sommelier IA : #{e.message}" }, status: :internal_server_error
  end
end

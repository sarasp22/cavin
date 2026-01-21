class WinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_storage, except: [:history]
  before_action :set_wine, only: [:show, :edit, :update, :destroy, :consume, :mark_consumed]

  def show
  end

  def new
    @wine = @storage.wines.build
  end

def create
  positions = params[:selected_positions].split(',') # Prende "1-1,1-2" e lo fa diventare ["1-1", "1-2"]

  if positions.empty?
    @wine = @storage.wines.build(wine_params) # Per mostrare errori di validazione
    flash.now[:alert] = "Veuillez sélectionner au moins un emplacement."
    render :new, status: :unprocessable_entity and return
  end

  errors = []

  # Usiamo una transazione: o si creano tutte o nessuna
  ActiveRecord::Base.transaction do
    positions.each do |pos|
      row, col = pos.split('-')
      @wine = @storage.wines.build(wine_params)
      @wine.row_position = row
      @wine.col_position = col

      unless @wine.save
        errors << @wine.errors.full_messages
        raise ActiveRecord::Rollback # Ferma tutto se una fallisce
      end
    end
  end

  if errors.empty?
    redirect_to storage_path(@storage), notice: "#{positions.count} vins ajoutés con succès!"
  else
    @wine = @storage.wines.build(wine_params)
    flash.now[:alert] = "Erreur lors dell'ajout: #{errors.first.join(', ')}"
    render :new, status: :unprocessable_entity
  end
end

  def edit
  end

  def update
    if @wine.update(wine_params)
      redirect_to storage_path(@storage), notice: 'Vin modifié avec succès!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wine.destroy
    redirect_to storage_path(@storage), notice: 'Vin supprimé avec succès!'
  end

  def consume
  end

def mark_consumed
  if @wine.update(consumed_at: Time.current, notes: params[:wine][:notes])
    if params[:save_as_template] == "1"
      current_user.wine_templates.find_or_create_by(
        name: @wine.name,
        wine_type: @wine.wine_type,
        region: @wine.region
      ) do |t|
        t.price = @wine.price
      end
    end

    redirect_to storage_path(@storage), notice: 'Vin marqué comme consommé!'
  else
    render :consume, status: :unprocessable_entity
  end
end

  def history
    @consumed_wines = current_user.storages.includes(:wines).flat_map do |storage|
      storage.wines.where.not(consumed_at: nil)
    end.sort_by(&:consumed_at).reverse
  end

  private

  def set_storage
    @storage = current_user.storages.find(params[:storage_id])
  end

  def set_wine
    @wine = @storage.wines.find(params[:id])
  end

  def wine_params
    params.require(:wine).permit(:name, :wine_type, :region, :price, :row_position, :col_position)
  end

  def wine_consume_params
    params.require(:wine).permit(:notes)
  end
end

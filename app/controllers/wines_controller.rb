class WinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_storage, except: [:history]
  before_action :set_wine, only: [:show, :edit, :update, :destroy, :consume, :mark_consumed]

  def new
    @wine = @storage.wines.build(
      row_position: params[:row],
      col_position: params[:col],
      size: "75cl"
    )
    @occupied_positions = @storage.wines.where(consumed_at: nil).pluck(:row_position, :col_position)
  end

  def create
    positions = params[:selected_positions].to_s.split(",").map(&:strip).reject(&:blank?)

    if positions.empty? && wine_params[:row_position].present? && wine_params[:col_position].present?
      positions = ["#{wine_params[:row_position]}-#{wine_params[:col_position]}"]
    end

    if positions.empty?
      @wine = @storage.wines.build(wine_params)
      @occupied_positions = @storage.wines.where(consumed_at: nil).pluck(:row_position, :col_position)
      flash.now[:alert] = "Veuillez sélectionner au moins un emplacement."
      render :new, status: :unprocessable_entity
      return
    end

    created_count = 0
    positions.each do |pos|
      row, col = pos.split("-").map(&:to_i)
      next unless row.positive? && col.positive?

      wine = @storage.wines.build(wine_params.merge(
        user: current_user,
        row_position: row,
        col_position: col
      ))
      created_count += 1 if wine.save
    end

    if created_count.positive?
      redirect_to storage_path(@storage), notice: "Vins ajoutés avec succès!"
    else
      @wine = @storage.wines.build(wine_params)
      @occupied_positions = @storage.wines.where(consumed_at: nil).pluck(:row_position, :col_position)
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    target_storage = if params.dig(:wine, :storage_id).present?
                       current_user.storages.find_by(id: params.dig(:wine, :storage_id)) || @storage
                     else
                       @storage
                     end

    if @wine.update(wine_params.merge(storage_id: target_storage.id))
      redirect_to storage_path(target_storage), notice: "Vin modifié avec succès!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wine.destroy
    redirect_to storage_path(@storage), notice: "Vin supprimé avec succès!"
  end

  def consume
  end

  def mark_consumed
    rating_val = params.dig(:wine, :rating) || params[:rating] || 5
    notes_val = params.dig(:wine, :notes) || params[:notes]

    if @wine.update(consumed_at: Time.current, rating: rating_val, notes: notes_val)
      if params[:save_as_template] == "1"
        current_user.wine_templates.create(
          name: @wine.name,
          wine_type: @wine.wine_type,
          region: @wine.region,
          price: @wine.price,
          notes: @wine.notes
        )
      end
      redirect_to storage_path(@storage), notice: "Vin marqué comme consommé!"
    else
      render :consume, status: :unprocessable_entity
    end
  end

  def history
    @consumed_wines = current_user.wines.where.not(consumed_at: nil).includes(:storage).order(consumed_at: :desc)
  end

  private

  def set_storage
    @storage = current_user.storages.find(params[:storage_id])
  end

  def set_wine
    @wine = @storage.wines.find(params[:id])
  end

  def wine_params
    params.require(:wine).permit(:name, :wine_type, :region, :price, :size, :row_position, :col_position, :notes, :rating, :storage_id)
  end
end

class WinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_storage, except: [:history]
  before_action :set_wine, only: [:show, :edit, :update, :destroy, :consume, :mark_consumed]

  def show
  end

  def new
    @wine = Wine.new
  end

  def create
    positions = params[:selected_positions].to_s.split(',').reject(&:blank?)

    if positions.empty?
      @wine = Wine.new(wine_params)
      flash.now[:alert] = "Veuillez sélectionner au moins un emplacement."
      render :new, status: :unprocessable_entity and return
    end

    begin
      ActiveRecord::Base.transaction do
        positions.each do |pos|
          row, col = pos.strip.split('-')

          new_wine = Wine.new(wine_params)
          new_wine.storage = @storage
          new_wine.user = current_user
          new_wine.row_position = row.to_i
          new_wine.col_position = col.to_i

          new_wine.save!
        end
      end
      redirect_to storage_path(@storage), notice: "Vins ajoutés avec succès!"
    rescue => e
     puts "ERRORE SALVATAGGIO: #{e.message}"
     @wine = Wine.new(wine_params)
     flash.now[:alert] = "Erreur: #{e.message}"
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
  @wine = Wine.find(params[:id])
  @storage = Storage.find(params[:storage_id])

  rating_from_form = params[:wine][:rating]

  if @wine.update(
    consumed_at: Time.current,
    notes: params[:wine][:notes],
    rating: rating_from_form.to_i
  )
    redirect_to storage_path(@storage), notice: 'Vin marqué comme consommé!'
  else
    render :consume, status: :unprocessable_entity
  end
end

  def history
    @consumed_wines = current_user.wines.where.not(consumed_at: nil).order(consumed_at: :desc)
  end

  private

  def set_storage
    @storage = current_user.storages.find(params[:storage_id])
  end

  def set_wine
    @wine = @storage.wines.find(params[:id])
  end

  def wine_params
    params.require(:wine).permit(:name, :wine_type, :region, :price, :size, :row_position, :col_position,:notes, :rating)
  end

def wine_consume_params
  params.require(:wine).permit(:notes, :rating)
end
end

class WinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_storage
  before_action :set_wine, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @wine = @storage.wines.build
  end

  def create
    @wine = @storage.wines.build(wine_params)

    if @wine.save
      redirect_to storage_path(@storage), notice: 'Vin ajouté avec succès!'
    else
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

  def history
    @consumed_wines = current_user.storages.includes(:wines).flat_map do |storage|
      storage.wines.where.not(consumed_at: nil)
    end.sort_by(&:consumed_at).reverse
  end

  def consume
    @storage = current_user.storages.find(params[:storage_id])
    @wine = @storage.wines.find(params[:id])

    @wine.update(consumed_at: Time.current)
    redirect_to storage_path(@storage), notice: 'Vin marqué comme consommé!'
  end

  private

  def set_storage
    @storage = current_user.storages.find(params[:storage_id]) if params[:storage_id]
  end

  def set_wine
    @wine = @storage.wines.find(params[:id])
  end

  def wine_params
    params.require(:wine).permit(:name, :wine_type, :region, :price, :row_position, :col_position)
  end
end

class StoragesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_storage, only: [:show, :edit, :update, :destroy]

  def index
    @storages = current_user.storages.includes(:wines)
  end

  def show
    @wines = @storage.wines.where(consumed_at: nil)
  end

  def new
    @storage = Storage.new
  end

  def create
    @storage = current_user.storages.build(storage_params)
    @storage.photo_url = set_default_photo(@storage.category)

    if @storage.save
      redirect_to storages_path, notice: 'Stockage créé avec succès!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

def update
  @storage.assign_attributes(storage_params)
  @storage.photo_url = set_default_photo(@storage.category)

  if @storage.save
    redirect_to storage_path(@storage), notice: 'Stockage modifié avec succès!'
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @storage = current_user.storages.find(params[:id])
  @storage.destroy

  respond_to do |format|
    format.html { redirect_to storages_path, status: :see_other, notice: 'Stockage supprimé avec succès!' }
    format.json { head :no_content }
  end
end

  private

  def set_storage
    @storage = current_user.storages.find(params[:id])
  end

  def storage_params
    params.require(:storage).permit(:name, :category, :rows, :cols)
  end

def set_default_photo(category)
  case category
  when "Cave"
    "cave.jpg"
  when "Vinothèque salon"
    "vinotheque_salon.png"
  when "Meuble cuisine"
    "meuble_cuisine.jpg"
  when "Vinothèque cuisine"
    "vinotheque_cuisine.png"
  else
    "default_storage.jpg"
  end
end
end

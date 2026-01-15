class StoragesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_storage, only: [:show, :edit, :update, :destroy]

  def index
    @storages = current_user.storages
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
    if @storage.update(storage_params)
      redirect_to storage_path(@storage), notice: 'Stockage modifié avec succès!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @storage.destroy
    redirect_to storages_path, notice: 'Stockage supprimé avec succès!'
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
      "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800"
    when "Vinothèque salon"
      "https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?w=800"
    when "Meuble cuisine"
      "https://images.unsplash.com/photo-1578911373434-0cb395d2cbfb?w=800"
    when "Vinothèque cuisine"
      "https://images.unsplash.com/photo-1568213816046-0ee1c42bd559?w=800"
    else
      "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800"
    end
  end
end

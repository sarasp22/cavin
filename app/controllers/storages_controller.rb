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
      redirect_to storage_path(@storage), notice: 'Stockage creato con successo!'
    else
      render :new, status: :unprocessable_entity
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
    when "Cave" then "cave.jpg"
    when "Vinothèque cucina" then "kitchen_wine.jpg"
    when "Vinothèque soggiorno" then "living_wine.jpg"
    else "default_storage.jpg"
    end
  end
end

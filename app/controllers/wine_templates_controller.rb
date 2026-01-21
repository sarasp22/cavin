class WineTemplatesController < ApplicationController
  before_action :authenticate_user!

  def index
    @wine_templates = current_user.wine_templates.order(created_at: :desc)
  end

  def create
    @wine_template = current_user.wine_templates.build(wine_template_params)

    if @wine_template.save
      respond_to do |format|
        format.html { redirect_to wine_templates_path, notice: 'Vin ajouté à votre bibliothèque!' }
        format.json { render json: @wine_template, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to wine_templates_path, alert: 'Erreur lors de l\'ajout' }
        format.json { render json: @wine_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @wine_template = current_user.wine_templates.find(params[:id])
    @wine_template.destroy
    redirect_to wine_templates_path, notice: 'Vin retiré de votre bibliothèque'
  end

  private

def wine_template_params
  params.require(:wine_template).permit(:name, :wine_type, :region, :price, :notes)
end
end

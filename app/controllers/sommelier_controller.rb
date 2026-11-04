class SommelierController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
    @request_text = params[:request].to_s
    @result = SommelierAdvisor.new(current_user).call(@request_text)
    render :index
  end
end

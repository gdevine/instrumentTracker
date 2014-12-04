class ModelsController < ApplicationController
  def index
    @models = Model.paginate(page: params[:page])
  end

  def show
    @model = Model.find(params[:id])
    @instruments = @model.instruments.paginate(page: params[:page], :per_page => 10)
  end
end

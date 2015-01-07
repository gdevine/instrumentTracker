class ModelsController < ApplicationController
  def index
    @models = Model.paginate(page: params[:page])
  end

  def show
    @model = Model.find(params[:id])
    # @instruments = @model.instruments.paginate(page: params[:page], :per_page => 20)
    @instruments = @model.instruments # Now using datatables for index table - no need for pagination
  end
end

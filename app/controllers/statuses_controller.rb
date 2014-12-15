class StatusesController < ApplicationController
  before_action :set_status_type
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  
  def index
    if params[:instrument_id]
      @statuses = status_type_class.where(instrument_id:params[:instrument_id]).paginate(page: params[:page])
    else
      @statuses = status_type_class.paginate(page: params[:page])
    end
  end

  def show
    @status = Status.find(params[:id])
    @instrument = @status.instrument
  end
# 
  # def new
  # end
# 
  # def edit
  # end
# 
  # def create
  # end
# 
  # def update
  # end
# 
  # def destroy
  # end
  
  
  private

    def set_status_type 
      @status_type = status_type 
    end

    def status_type 
      Status.status_types.include?(params[:status_type]) ? params[:status_type] : "Status"
    end
    
    def status_type_class 
      status_type.constantize 
    end
end

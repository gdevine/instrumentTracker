class ServicesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,  only: [:edit, :update, :destroy]
  
  def index
   @services = Service.paginate(page: params[:page])
  end

  # def new
  # end
# 
  # def create
  # end
# 
  # def edit
  # end
# 
  # def update
  # end

  def show
    @service = Service.find(params[:id])
  end

  def destroy
    @service.destroy
    redirect_to services_path
  end
   
  
  private

    def service_params
      params.require(:service).permit(:problem, :startdatetime, :enddatetime, :comments, :reporter_id)
    end
    
    def correct_user
      @service = Service.find_by(id:params[:id])
      @inst_id = @service.instrument.id
      @instrument = current_user.instruments.find_by(id: @inst_id)
      redirect_to root_url if @instrument.nil?
    end
end

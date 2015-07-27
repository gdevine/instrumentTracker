class ServicesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user,  only: [:edit, :update, :destroy]
  
  load_and_authorize_resource :instrument
  load_and_authorize_resource :service, :through => :instrument, :shallow => true
  
  
  def index
   @services = Service.paginate(page: params[:page], :per_page => 20)
  end

  def new
    @instrument = Instrument.find(params[:instrument_id])
    @service = Service.new
  end

  def create
    @instrument = Instrument.find(service_params[:instrument_id])
    @service = @instrument.services.build(service_params)
    @service.reporter = current_user
    
    if @service.save
      flash[:success] = "Service record created!"
      redirect_to @service
    else
      @services = []
      @instrument = Instrument.find(service_params[:instrument_id])
      render 'services/new'
    end
  end

  def edit
    @service = Service.find(params[:id])
    @instrument = @service.instrument
  end

  def update
    @service = Service.find(params[:id])
    @instrument = @service.instrument
    if @service.update_attributes(service_params)
      flash[:success] = "Service updated"
      redirect_to @service
    else
      render 'edit'
    end
  end

  def show
    @service = Service.find(params[:id])
    @instrument = @service.instrument
  end

  def destroy
    @service.destroy
    redirect_to services_path
  end
   
  
  private

    def service_params
      params.require(:service).permit(:instrument_id, :problem, :startdatetime, :enddatetime, :comments, :reporter_id)
    end
    
    def correct_user
      @service = Service.find_by(id:params[:id])
      @inst_id = @service.instrument.id
      @instrument = current_user.instruments.find_by(id: @inst_id)
      redirect_to root_url if @instrument.nil?
    end
end

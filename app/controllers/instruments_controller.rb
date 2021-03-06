class InstrumentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource
  
  def index   
    @instruments = Instrument.all   # Now using datatables for index table - no need for pagination
  end
  
  def new
    if Model.count == 0
      flash[:error] = "New Instruments can't be added until at least one Instrument Model is added to the system. Contact the admin to do this."
      redirect_to root_url
    else
      @instrument = Instrument.new
      @instrument.instrument_users.build
    end
  end

  def create
    @instrument = Instrument.create(instrument_params)
    if @instrument.save
      current_user.instruments << @instrument
      flash[:success] = "Instrument created!"
      redirect_to @instrument
    else
      @instruments = []
      render 'new'
    end
  end
  
  def show
    @instrument = Instrument.find(params[:id])
    @services = @instrument.services.paginate(page: params[:page], :per_page => 20)
    @statuses = @instrument.statuses.paginate(page: params[:page], :per_page => 20)
    @current_status = @instrument.current_status
  end
  
  def edit
    @instrument = Instrument.find(params[:id])
  end
     
  def update
    @instrument = Instrument.find(params[:id])
    if @instrument.update_attributes(instrument_params)
      current_user.instruments << @instrument
      flash[:success] = "Instrument updated"
      redirect_to @instrument
    else
      render 'edit'
    end
  end
  
  def destroy
    @instrument.destroy
    redirect_to instruments_path
  end
  
  
  private

    def instrument_params
      params.require(:instrument).permit(:model_id, :fundingSource, :assetNumber, :serialNumber, :supplier, :purchaseDate, :retirementDate, :price, :user_ids=> [])
    end
    
    def correct_user
      @instrument = current_user.instruments.find_by(id: params[:id])
      redirect_to root_url if @instrument.nil?
    end

  
end

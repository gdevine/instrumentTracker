class InstrumentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,  only: [:edit, :update, :destroy]
  
  def index   
    @instruments = Instrument.paginate(page: params[:page])
  end
  
  def new
    if Model.count == 0
      flash[:error] = "New Instruments can't be added until at least one Instrument Model is added to the system. Contact the admin to do this."
      redirect_to root_url
    else
      @instrument = Instrument.new
    end
  end

  def create
    @instrument = Instrument.new(instrument_params)
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
  end
  
    def edit
    @instrument = Instrument.find(params[:id])
  end
     
  def update
    @instrument = Instrument.find(params[:id])
    if @instrument.update_attributes(instrument_params)
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
      params.require(:instrument).permit(:model_id, :serialNumber, :supplier, :purchaseDate, :retirementDate, :price)
    end
    
    def correct_user
      @instrument = current_user.instruments.find_by(id: params[:id])
      redirect_to root_url if @instrument.nil?
    end

  
end

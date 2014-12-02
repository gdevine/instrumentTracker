class InstrumentsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  
  def index   
    @instruments = Instrument.paginate(page: params[:page])
  end
  
  def new
    @instrument = Instrument.new
  end

  def create
    @instrument = Instrument.new(instrument_params)
    if @instrument.save
      current_user.instruments << @instrument
      flash[:success] = "Instrument created!"
      redirect_to instruments_path
    else
      @instruments = []
      render 'new'
    end
  end
  
  
  private

    def instrument_params
      params.require(:instrument).permit(:serialNumber, :supplier, :purchaseDate, :retirementDate, :price)
    end
    
    def correct_user
      @instrument = current_user.instruments.find_by(id: params[:id])
      redirect_to root_url if @sample_set.nil?
    end

  
end

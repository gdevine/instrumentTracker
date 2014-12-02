class InstrumentsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  
  def index   
    @instruments = Instrument.paginate(page: params[:page])
  end
  
end

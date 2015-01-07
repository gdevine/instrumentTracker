class StaticPagesController < ApplicationController
  def home
  end
  
  def dashboard
    @total_instruments = Instrument.all.count
    # @face_instruments = current_FACE_instruments.count
  end

  def about
  end
  
  def contact
  end
  
  def help
  end
end

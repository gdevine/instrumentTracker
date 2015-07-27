class StaticPagesController < ApplicationController
  authorize_resource :class => StaticPagesController
  
  def home
  end
  
  def dashboard
    @total_instruments = Instrument.all.count
  end

  def about
  end
  
  def contact
  end
  
  def help
  end
end

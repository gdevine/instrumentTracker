module InstrumentsHelper
  
  def current_instruments(statustype)
    # Will return an array of instruments whose current status_type is equal to statustype
    
    current_instruments = []
    Instrument.all.each do |i| 
      if !i.statuses.empty?
        if i.current_status.status_type == statustype
          current_instruments << i
        end
      end
    end
    return current_instruments   
  end
  
end

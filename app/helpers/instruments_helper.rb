module InstrumentsHelper
  
  def current_instruments(statustype)
    # Will return an array of instruments whose current status_type is equal to statustype
    
    current_instruments = []
    Instrument.all.each do |i| 
      if !i.statuses.empty?
        if !i.current_status.nil? && i.current_status.status_type == statustype  # first clause is to weed out instrument that only have statuses in the future
          current_instruments << i
        end
      end
    end
    return current_instruments   
  end
  
  def unassigned_instruments
    unassigned = []
    Instrument.all.each do |i| 
      # First deal with instruments with no statuses assigned
      if i.statuses.empty?
        unassigned << i
      else
      #then for instruments with statuses only in the future
        if i.current_status.nil?
          unassigned << i
        end  
      end
    end
    return unassigned   
  end
  
end

class Retirement < Status
  
  default_scope -> { order('created_at DESC') }
  
  validates_inclusion_of :status_type, in: ['Retirement']
  validate :check_one_retirement
  validate :retirement_last

  private 
  
    def check_one_retirement
      #checks that an instrument has only one retirement status record
      if self.instrument
        retireds = self.instrument.statuses.retired
        # for an edit remove the current retirment status
        if !retireds.empty?
          retireds = retireds.reject { |u| u==self }
        end 
        errors.add(:base, "An Instrument can only be retired once") if !retireds.empty?
      end
    end
    
    def retirement_last
      #checks that a retirement status is the latest status
      if self.instrument
        latest = self.instrument.statuses.first # is ordered by date by default
        if latest && self.startdate
          errors.add(:base, "A more recent status exists - Retirement date must not precede other statuses ") if latest.startdate.to_date > self.startdate.to_date
        end
      end
    end
    
end

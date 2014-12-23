class Status < ActiveRecord::Base
  belongs_to :instrument, :class_name => 'Instrument', :foreign_key => 'instrument_id'
  belongs_to :reporter, :class_name => 'User', :foreign_key => 'reporter_id'
  
  self.inheritance_column = :status_type
  # We will need a way to know which statuses
  # will subclass the Status model
  def self.status_types
    %w(Loan Lost)
  end
  
  default_scope -> { order('startdate DESC') }
  
  validates :startdate, presence: true
  validates :status_type, presence: true
  validates :instrument_id, presence:true
  validates :reporter_id, presence:true
  
  validate :validate_instrument_id
  validate :validate_reporter_id
  validate :start_before_end
  
  
  private 
    
    def validate_instrument_id
      errors.add(:instrument_id, "is invalid") unless Instrument.exists?(self.instrument_id)
    end
      
    def validate_reporter_id
      errors.add(:reporter_id, "is invalid") unless User.exists?(self.reporter_id)
    end  
    
    def start_before_end
      if !self.startdate.nil? && !self.startdate!="" && !self.enddate.nil? && !self.enddate!=""
        errors.add(:base, "End Date cannot precede Start Date") if self.startdate > self.enddate
      end
    end  
  
end

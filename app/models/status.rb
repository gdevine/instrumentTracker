class Status < ActiveRecord::Base
  belongs_to :instrument, :class_name => 'Instrument', :foreign_key => 'instrument_id'
  belongs_to :reporter, :class_name => 'User', :foreign_key => 'reporter_id'
  belongs_to :storage_location, :class_name => 'StorageLocation', :foreign_key => 'storage_location_id'
  
  self.inheritance_column = :status_type
  # We will need a way to know which statuses
  # will subclass the Status model
  def self.status_types
    ['Loan', 'Lost', 'Facedeployment', 'Storage', 'Retirement']
  end
  
  default_scope -> { order('startdate DESC') }
  scope :retired, -> { where(status_type: 'Retirement') }
    
  validates :startdate, presence: true
  validates :status_type, presence: true
  validates :instrument_id, presence:true
  validates :reporter_id, presence:true
  
  validate :validate_instrument_id
  validate :validate_reporter_id
  validate :check_start_before_end
  # validate :check_retirement_last
  
  def status_type_text
    case status_type
    when 'Loan'
      'Loan'
    when 'Lost'
      'Lost'
    when 'Retirement'
      'Retired'
    when 'Facedeployment'
      'FACE Deployment'
    when 'Storage'
      'In Storage'
    else
      'Status'
    end
  end
  
  def current
    # Returns true/false whether this is the current status
      Status.where(instrument_id:self.instrument_id).where('startdate <= ?', Date.today).order('startdate DESC').order('created_at DESC').first == self
  end
 
  
  private 
    
    def validate_instrument_id
      errors.add(:instrument_id, "is invalid") unless Instrument.exists?(self.instrument_id)
    end
      
    def validate_reporter_id
      errors.add(:reporter_id, "is invalid") unless User.exists?(self.reporter_id)
    end  
    
    def check_start_before_end
      if !self.startdate.nil? && !self.startdate!="" && !self.enddate.nil? && !self.enddate!=""
        errors.add(:base, "End Date cannot precede Start Date") if self.startdate > self.enddate
      end
    end  
    
    def check_retirement_last
      retired = self.instrument.statuses.retired.first
      if retired
        errors.add(:base, "Statuses can only be added prior to an Instrument Retirement") if retired.startdate < self.startdate
      end
    end
  
end

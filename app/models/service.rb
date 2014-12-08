class Service < ActiveRecord::Base
  belongs_to :instrument, :class_name => 'Instrument', :foreign_key => 'instrument_id'
  belongs_to :reporter, :class_name => 'User', :foreign_key => 'reporter_id'
  
  default_scope -> { order('created_at DESC') }
  
  validates :startdatetime, presence: true
  validates :problem, presence: true
  validates :instrument_id, presence:true
  validates :reporter_id, presence:true
  
  validate :validate_instrument_id
  validate :validate_reporter_id
  
  
  private 
    
  def validate_instrument_id
    errors.add(:instrument_id, "is invalid") unless Instrument.exists?(self.instrument_id)
  end
    
  def validate_reporter_id
    errors.add(:reporter_id, "is invalid") unless User.exists?(self.reporter_id)
  end    
  
end

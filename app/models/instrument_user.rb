class InstrumentUser < ActiveRecord::Base
  belongs_to :instrument, :class_name => 'Instrument', :foreign_key => 'instrument_id' 
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  
  accepts_nested_attributes_for :user
  
  validates_presence_of :instrument, :user
end

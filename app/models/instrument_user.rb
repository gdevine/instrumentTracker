class InstrumentUser < ActiveRecord::Base
  belongs_to :instrument, :class_name => 'Instrument', :foreign_key => 'instrument_id'
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
end

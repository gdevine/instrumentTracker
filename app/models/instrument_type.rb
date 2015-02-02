class InstrumentType < ActiveRecord::Base
  
  has_many :models, :class_name => 'Model', :foreign_key => 'instrument_type_id', :dependent => :restrict_with_exception
  
  # Order by name
  default_scope -> { order(name: :asc) }
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
end

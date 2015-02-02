class Model < ActiveRecord::Base
  has_many :instruments, :class_name => 'Instrument', :foreign_key => 'model_id', :dependent => :restrict_with_exception
  belongs_to :instrument_type, :class_name => 'InstrumentType', :foreign_key => 'instrument_type_id'
  belongs_to :manufacturer, :class_name => 'Manufacturer', :foreign_key => 'manufacturer_id'
  
  # Order by manufacturer then model name
  default_scope -> { order(name: :asc) }
  
  validates :manufacturer_id, presence: true
  validates :instrument_type_id, presence: true
  validates :name, presence: true
  validates :manufacturer, :uniqueness => {:scope => [:name], message: "A model name by that manufacturer already exists"}
  
  
  def full_name
    "#{manufacturer.name} #{name} (#{instrument_type.name})".strip
  end
  
end

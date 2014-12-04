class Model < ActiveRecord::Base
  has_many :instruments, :class_name => 'Instrument', :foreign_key => 'model_id', :dependent => :restrict_with_exception
  
  # Order by manufacturer then model name
  default_scope -> { order(manufacturer: :asc, modelName: :asc) }
  
  validates :modelType, presence: true
  validates :manufacturer, presence: true
  validates :modelName, presence: true
  validates :manufacturer, :uniqueness => {:scope => [:modelName], message: "A model name by that manufacturer already exists"}
  
  
  def full_name
    "#{manufacturer} #{modelName} (#{modelType})".strip
  end
  
end

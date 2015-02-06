class Retirement < Status
  validates_inclusion_of :status_type, in: ['Retirement']
  
  default_scope -> { order('created_at DESC') }
end

class Lost < Status
  validates_inclusion_of :status_type, in: ['Lost']
  
  default_scope -> { order('created_at DESC') }
end

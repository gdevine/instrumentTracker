class Storage < Status
  validates :storage_location, presence: true
  validates_inclusion_of :status_type, in: ['Storage']
  
  default_scope -> { order('created_at DESC') }
end
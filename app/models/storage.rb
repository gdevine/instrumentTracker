class Storage < Status
  validates :storage_location_id, presence: true
  validates_inclusion_of :status_type, in: ['Storage']
  
  default_scope -> { order('created_at DESC') }
end
class Deployment < Status
  validates :site_id, presence: true
  validates_inclusion_of :status_type, in: ['Deployment']
  
  default_scope -> { order('created_at DESC') }
end
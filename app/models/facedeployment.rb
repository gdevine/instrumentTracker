class Facedeployment < Status
  validates :ring, presence: true
  validates_inclusion_of :status_type, in: ['Facedeployment']
  
  default_scope -> { order('created_at DESC') }
end
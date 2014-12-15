class Loan < Status
  validates :loaned_to, presence: true
  validates_inclusion_of :status_type, in: ['Loan']
  
  default_scope -> { order('created_at DESC') }
end

class Instrument < ActiveRecord::Base
  has_many :instrument_users, :dependent => :destroy
  has_many :users, :through => :instrument_users
  belongs_to :model, :class_name => 'Model', :foreign_key => 'model_id'
  
  default_scope -> { order('created_at DESC') }
  
  validates :serialNumber, presence: true, uniqueness: { case_sensitive: false }
  validates :model, presence: true
  
  # validate :require_at_least_one_user
  validate :limit_to_three_users
  
  
  private

    def require_at_least_one_user
      errors.add(:base, "An instrument must have at least one user associated with it") if
        self.users.count == 0 
    end
    
    def limit_to_three_users
      errors.add(:base, "An instrument can not have more than three users associated with it") if
        self.users.count > 3 
    end

end

class Instrument < ActiveRecord::Base
  has_many :instrument_users, :dependent => :destroy
  has_many :users, :through => :instrument_users
  has_many :services, :class_name => 'Service', :foreign_key => 'instrument_id', :dependent => :destroy
  belongs_to :model, :class_name => 'Model', :foreign_key => 'model_id'
  
  default_scope -> { order('created_at DESC') }
  
  validates :serialNumber, presence: true
  validates :assetNumber, presence: true
  validates :model, presence: true
  validates :model, :uniqueness => {:scope => [:serialNumber], message: "This Serial Number is already in use for an instrument of the same model"}
  
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

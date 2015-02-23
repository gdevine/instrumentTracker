class Instrument < ActiveRecord::Base
  has_many :instrument_users, :dependent => :destroy, inverse_of: :instrument
  has_many :users, :through => :instrument_users
  has_many :services, :class_name => 'Service', :foreign_key => 'instrument_id', :dependent => :destroy
  has_many :statuses, :class_name => 'Status', :foreign_key => 'instrument_id', :dependent => :destroy
  belongs_to :model, :class_name => 'Model', :foreign_key => 'model_id'
  
  accepts_nested_attributes_for :instrument_users
  
  default_scope -> { order('created_at DESC') }
  
  validates :serialNumber, :presence => { :message => "Serial Number is required" }
  validates :purchaseDate, :presence => { :message => "Purchase Date is required" }
  validates :model, :presence => { :message => "Model is required" }
  validates :model, :uniqueness => {:scope => [:serialNumber], message: "This Serial Number is already in use for an instrument of the same model"}
  
  # validate :require_at_least_one_user
 
  def current_status
    # Return the current status based on start dates
    if !self.statuses.empty?
      stat = Status.where(instrument_id:self.id).where('startdate <= ?', Date.today).order('startdate DESC').order('created_at DESC').first
    end
  end
  
  
  private

    def require_at_least_one_user
      if !self.id.nil?
        errors.add(:base, "An instrument must have at least one user associated with it") if
          self.users.count == 0 
      end
    end
    
end

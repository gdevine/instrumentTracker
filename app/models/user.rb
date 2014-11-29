class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  before_save { self.email = email.downcase }
  after_create :send_admin_mail, :send_welcome_mail
  
  validates :firstname, presence: true , length: { maximum: 50 }
  validates :surname, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
                    
  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end
  
  def send_admin_mail
    UserMailer.new_user_waiting_for_approval(self).deliver
  end
  
  def send_welcome_mail
    UserMailer.welcome_email(self).deliver
  end
  
  
end
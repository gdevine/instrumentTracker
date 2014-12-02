class UserMailer < ActionMailer::Base
  default from: 'notifications@instrumenttracker.com'
 
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to HIE Instrument Tracker')
  end
  
  def new_user_waiting_for_approval(user)
    @user = user
    mail(to: 'g.devine@uws.edu.au', subject: 'Base App 1 Registration Request from #{@user.email}')
  end
end
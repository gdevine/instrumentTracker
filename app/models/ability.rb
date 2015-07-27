class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    
    alias_action :create, :read, :update, :destroy, :to => :crud
    
    # Guest users
    can [:home, :about, :contact, :help, :dashboard], StaticPagesController
    can [:index, :show], Instrument
    can [:index, :show], Status
    can [:index, :show], Service
    
    
    if user.role == "technician" && user.approved == true
      can [:home, :about, :contact, :help, :dashboard], StaticPagesController
      can [:index, :show, :new, :create], Instrument
      can [:index, :show], Status
      can [:edit, :update, :destroy], Instrument do |instrument|
        instrument.users.include? user
      end
      
      # For working on a status indirectly, i.e. nested through an instrument
      can :manage, Status, Instrument do |status| 
        status.instrument.users.include? user
      end
      # For working on a status indirectly, i.e. nested through an instrument
      can :manage, Service, Instrument do |service| 
        service.instrument.users.include? user
      end
    end    
    
    
    if user.role == "custodian" && user.approved == true
      can [:home, :about, :contact, :help, :dashboard], StaticPagesController
      can [:index, :show], Instrument
      
      ## Commenting this out for now which means custodians can not directly edit the details of an instrument, only the attached statuses etc
      can [:edit, :update], Instrument do |instrument|
        instrument.users.include? user
      end  

      # For working on a status directly, i.e. not nested through an instrument
      can [:index, :show], Status   

      # For working on a service directly, i.e. not nested through an instrument
      can [:index, :show], Service 
      
      # For working on a status indirectly, i.e. nested through an instrument
      can :manage, Status, Instrument do |status| 
        status.instrument.users.include? user
      end
      
      # For working on a status indirectly, i.e. nested through an instrument
      can :manage, Service, Instrument do |service| 
        service.instrument.users.include? user
      end
   
    end    
    
    
    if user.role == "admin" && user.approved == true     
      can :manage, :all 
    end
    
  end
end

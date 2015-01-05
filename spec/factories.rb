FactoryGirl.define do
  
  factory :user do
    sequence(:firstname)  { |n| "Person_#{n}" }
    sequence(:surname)  { |n| "BlaBla_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar100"
    password_confirmation "foobar100"  
    approved true
  end
  
  factory :model do
    sequence(:modelType) { |n| "mtype_#{n}" }
    sequence(:manufacturer) { |n| "man_#{n}" }
    sequence(:modelName) { |n| "mname_#{n}" }
  end
    
  factory :instrument do
    sequence(:serialNumber) { |n| "aserialnumber_#{n}" }
    assetNumber 4
    purchaseDate Date.new(2012, 12, 3)
    fundingSource "ARC Grant"
    retirementDate Date.new(2014, 12, 3)
    supplier "A dummy supplier"
    price 2435.00
    
    association :model, :factory  => :model
  end

  factory :service do 
    startdatetime DateTime.new(2014, 12, 3)
    enddatetime DateTime.new(2014, 12, 5)
    reporteddate DateTime.now
    problem "This is a dummy issue with this instrument"
    comments "This is a dummy comment with this service"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :status do 
    startdate Date.new(2014, 12, 3)
    status_type "loan"
    comments "This is a dummy comment for this status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :loan do 
    startdate Date.new(2014, 12, 3)
    status_type "Loan"
    loaned_to 'the loanee'
    comments "This is a dummy comment for this loan"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :lost do 
    startdate Date.new(2014, 12, 3)
    status_type "Lost"
    comments "This is a dummy comment for this lost status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :facedeployment do 
    startdate Date.new(2014, 12, 3)
    status_type "Facedeployment"
    ring 3
    comments "This is a dummy comment for this face deployment status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
    
end
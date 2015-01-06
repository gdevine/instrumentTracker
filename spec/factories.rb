FactoryGirl.define do
  
  factory :user do
    firstname { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.free_email }
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
    serialNumber { Faker::Company.duns_number }
    assetNumber { Faker::Company.ein }
    purchaseDate { Faker::Date.between(200.days.ago, 100.days.ago) }
    fundingSource "ARC Grant"
    retirementDate { Faker::Date.between(30.days.ago, Date.today) }
    supplier "A dummy supplier"
    price { Faker::Commerce.price }
    
    association :model, :factory  => :model
  end

  factory :service do 
    startdatetime { Faker::Date.between(100.days.ago, 90.days.ago) }
    enddatetime { Faker::Date.between(89.days.ago, 80.days.ago) }
    reporteddate DateTime.now
    problem "This is a dummy issue with this instrument"
    comments "This is a dummy comment with this service"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :status do 
    startdate { Faker::Date.between(100.days.ago, Date.today) }
    status_type "loan"
    comments "This is a dummy comment for this status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :loan do 
    startdate { Faker::Date.between(30.days.ago, Date.today) }
    status_type "Loan"
    loaned_to { Faker::Name.name }
    comments "This is a dummy comment for this loan"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :lost do 
    startdate { Faker::Date.between(60.days.ago, Date.today) }
    status_type "Lost"
    comments "This is a dummy comment for this lost status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :facedeployment do 
    startdate { Faker::Date.between(70.days.ago, Date.today) }
    status_type "Facedeployment"
    ring { Faker::Number.between(1, 6) }
    comments "This is a dummy comment for this face deployment status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
    
end
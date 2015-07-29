FactoryGirl.define do
    
  factory :user do
    firstname { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.free_email }
    password "foobar100"
    password_confirmation "foobar100"   
    approved true
    role "technician"
    
    factory :unapproved_user do
      approved false
    end
    
    factory :custodian do
      role "custodian"
    end
    
    factory :admin do
      role "admin"
    end  
      
  end
  
  factory :model do
    name { Faker::App.name }
    details "Some additional info about this "
    
    association :instrument_type, :factory  => :instrument_type
    association :manufacturer, :factory  => :manufacturer
  end

  factory :manufacturer do
    sequence(:name) {|n| Faker::Company.name + " (#{n})"}
    details "Some additional info about this "
  end
  
  factory :instrument_type do
    sequence(:name) {|n| ["Dendrometer", "Temperature Sensor", "Leaf Trap", "Lux Meter"].sample + " (#{n})"}
    details "Some additional info about this "
  end
    
  factory :instrument do
    serialNumber { Faker::Company.duns_number }
    assetNumber { Faker::Company.ein }
    purchaseDate { Faker::Date.between(200.days.ago, 100.days.ago) }
    fundingSource "ARC Grant"
    supplier { Faker::Company.name }
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
    startdate { Faker::Date.between(100.days.ago, 10.days.ago) }
    status_type "Loan"
    loaned_to { Faker::Name.name }
    comments "This is a dummy comment for this loan"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :lost do 
    startdate { Faker::Date.between(100.days.ago, 10.days.ago) }
    status_type "Lost"
    comments "This is a dummy comment for this lost status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :retirement do 
    startdate { Faker::Date.between(10.days.ago, Date.today) }
    status_type "Retirement"
    comments "This is a dummy comment for this retirement status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :facedeployment do 
    startdate { Faker::Date.between(100.days.ago, 100.days.ago) }
    status_type "Facedeployment"
    ring { Faker::Number.between(1, 6) }
    northing { Faker::Address.latitude }
    easting { Faker::Address.longitude }
    vertical { rand(-10.0..30.0) }
    comments "This is a dummy comment for this face deployment status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
  factory :storage_location do 
    code { Faker::Internet.domain_word }
    room { Faker::Address.building_number }
    building { Faker::Lorem.word }
    address { Faker::Address.street_address }
    comments "This is a dummy comment for this storage location"
  end
  
  factory :storage do 
    startdate { Faker::Date.between(100.days.ago, 10.days.ago) }
    status_type "Storage"
    comments "This is a dummy comment for this storage status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
    association :storage_location, :factory  => :storage_location
  end
  
  factory :site do 
    name { Faker::Address.street_name }
    shortname { Faker::Internet.domain_word }
    address { Faker::Address.street_address }
    description "This is a dummy description of this site"
    contact { Faker::Name.name }
    website { Faker::Internet.url }
  end
  
  factory :deployment do 
    status_type "Deployment"
    startdate { Faker::Date.between(100.days.ago, 10.days.ago) }
    location_identifier { Faker::Number.between(1, 600) }
    northing { Faker::Address.latitude }
    easting { Faker::Address.longitude }
    vertical { rand(-10.0..30.0) }
    comments "This is a dummy comment for this deployment status"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
    association :site, :factory  => :site
  end
    
end
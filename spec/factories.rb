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
    # model_id  1 
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
    # instrument_id  1 
    startdatetime DateTime.new(2014, 12, 3)
    enddatetime DateTime.new(2014, 12, 5)
    reporteddate DateTime.now
    problem "This is a dummy issue with this instrument"
    comments "This is a dummy comment with this instrument"
    
    association :instrument, :factory  => :instrument
    association :reporter, :factory  => :user
  end
  
end
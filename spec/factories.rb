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
    model_id  1 
    sequence(:serialNumber) { |n| "aserialnumber_#{n}" }
    assetNumber 4
    purchaseDate Date.new(2012, 12, 3)
    fundingSource "ARC Grant"
    retirementDate Date.new(2014, 12, 3)
    supplier "A dummy supplier"
    price 2435.00
    
    association :model, :factory  => :model
  end
  
end
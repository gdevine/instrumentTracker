FactoryGirl.define do
  factory :user do
    
    sequence(:firstname)  { |n| "Person_#{n}" }
    sequence(:surname)  { |n| "BlaBla_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar100"
    password_confirmation "foobar100"  
    approved true
    
    factory :admin do
      admin true
    end
    
  end
end
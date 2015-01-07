# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'factory_girl'
require Rails.root.join('spec/factories.rb')


# Users
5.times do
  FactoryGirl.create :user
end


# Models
model_list = [
  [ "Temperature Probe", "Sony", "VF432" ],
  [ "Data Logger", "Campbell", "CR1300" ],
  [ "Dendrometer", "Honeywell", "D54D100" ],
  [ "Lux Meter", "Toshiba", "90X" ],
  [ "NOx Monitor", "Campbell", "64D1000"]
]

model_list.each do |modelType, manufacturer, modelName|
  model = Model.create_with(:modelType => modelType).find_or_create_by(:manufacturer => manufacturer, :modelName => modelName  )
end


# Instruments
50.times do
  instrument = FactoryGirl.create(:instrument, model_id: rand(1..5))
  instrument.users << User.find(rand(1..5))
end

# Retired Instruments
5.times do
  instrument = FactoryGirl.create(:instrument, model_id: rand(1..5), retirementDate: Faker::Date.between(30.days.ago, Date.today))
  instrument.users << User.find(rand(1..5))
end


# Services
100.times do
  service = FactoryGirl.create(:service, instrument_id:rand(1..30), reporter_id:rand(1..5))    
end

# Loans
25.times do
  loan = FactoryGirl.create(:loan, instrument_id:rand(1..50), reporter_id:rand(1..5))    
end

# Losts
25.times do
  lost = FactoryGirl.create(:lost, instrument_id:rand(1..50), reporter_id:rand(1..5))    
end

# FACE Deployments
25.times do
  facedeployment = FactoryGirl.create(:facedeployment, instrument_id:rand(1..50), reporter_id:rand(1..5))    
end
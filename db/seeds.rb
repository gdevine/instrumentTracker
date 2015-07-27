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
# Create a user for developer to work with
User.create(firstname:'Gerard', surname:'Devine', email:'g.devine@uws.edu.au', password:'qwertyui', password_confirmation:'qwertyui', approved:true, role:'admin')
# Create one unapproved user
FactoryGirl.create :unapproved_user
# Create some approved users
5.times do
  FactoryGirl.create :user
end


# Manufacturers
manufacturer_list = ["Sony", "Campbell", "Honeywell", "Toshiba", "Siemens"]

# Instrument Types
instrument_type_list = ["Temperature Probe", "Data Logger", "Dendrometer", "Lux Meter", "NOx Monitor"]

# Models
model_list = ["VF432", "CR1300", "D54D100", "90X", "64D1000"]


manufacturer_list.each do |manufacturer|
  man = Manufacturer.create(name: manufacturer, details:'Some extra info about this Manufacturer')
end

instrument_type_list.each do |it|
  instrument_type = InstrumentType.create(:name => it, details:'Some extra info about this Instrument Type')
end

model_list.each_with_index do |it, index|
  model = Model.create(:name => it, details:'Some extra info about this Model', instrument_type_id:index+1, manufacturer_id:index+1)
end

# Create some instrument type - manufacturer - models


# Instruments
50.times do
  instrument = FactoryGirl.create(:instrument, model_id: rand(1..5))
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

# Retired Instruments
5.times do
  storage = FactoryGirl.create(:storage, instrument_id:rand(1..50), reporter_id:rand(1..5))    
end

# Retired Instruments
3.times do
  retired = FactoryGirl.create(:retirement, instrument_id:rand(1..50), reporter_id:rand(1..5))    
end
require 'spec_helper'

describe Deployment do
  let(:technician) {FactoryGirl.create(:user) }
  
  before do
    @instrument = FactoryGirl.create(:instrument)
    @instrument.users << technician
    @instrument.save
    @deployment = FactoryGirl.build(:deployment, instrument_id:@instrument.id, reporter_id:technician.id)
  end
  
  subject { @deployment }
  
  it { should respond_to(:id) }
  it { should respond_to(:startdate) }
  it { should respond_to(:comments) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:instrument) }
  it { should respond_to(:reporter_id) }
  it { should respond_to(:reporter) }
  it { should respond_to(:status_type) }
  it { should respond_to(:location_identifier) }
  it { should respond_to(:northing) }
  it { should respond_to(:easting) }
  it { should respond_to(:vertical) }
 
  it { should be_valid }
  
  describe "when startdate is not present" do
    before { @deployment.startdate = nil }
    it { should_not be_valid }
  end

  describe "when location_identifier is not present" do
    before { @deployment.location_identifier = nil }
    it { should be_valid }
  end
  
  describe "when status_type is not present" do
    before { @deployment.status_type = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not 'Deployment'" do
    before { @deployment.status_type = 'nonstatus' }
    it { should_not be_valid }
  end
  
  describe "when status_type is a different valid status type" do
    before { @deployment.status_type = 'Loan' }
    it { should_not be_valid }
  end
   
  describe "when instrument is not present" do
    before do 
      @deployment.instrument = nil
    end
    it { should_not be_valid }
  end
  
  describe "when instrument does not exist" do
    before { @deployment.instrument_id = 10000 }
    it { should_not be_valid }
  end

  describe "when reporter is not present" do
    before { @deployment.reporter = nil }
    it { should_not be_valid }
  end
  
  describe "when reporter does not exist" do
    before { @deployment.reporter_id = 10000 }
    it { should_not be_valid }
  end
end

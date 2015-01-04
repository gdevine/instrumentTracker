require 'spec_helper'

describe Facedeployment do
  let(:user1) {FactoryGirl.create(:user) }
  
  before do
    @instrument = FactoryGirl.create(:instrument)
    @instrument.users << user1
    @instrument.save
    @face_deploy = FactoryGirl.build(:facedeployment, instrument_id:@instrument.id, reporter_id:user1.id)
  end
  
  subject { @face_deploy }
  
  it { should respond_to(:id) }
  it { should respond_to(:startdate) }
  it { should respond_to(:comments) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:instrument) }
  it { should respond_to(:reporter_id) }
  it { should respond_to(:reporter) }
  it { should respond_to(:status_type) }
  it { should respond_to(:ring) }
  it { should respond_to(:northing) }
  it { should respond_to(:easting) }
  it { should respond_to(:vertical) }
 
  it { should be_valid }
  
  describe "when startdate is not present" do
    before { @face_deploy.startdate = nil }
    it { should_not be_valid }
  end

  describe "when ring is not present" do
    before { @face_deploy.ring = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not present" do
    before { @face_deploy.status_type = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not 'Face Deployment'" do
    before { @face_deploy.status_type = 'nonstatus' }
    it { should_not be_valid }
  end
  
  describe "when instrument is not present" do
    before do 
      @face_deploy.instrument = nil
    end
    it { should_not be_valid }
  end
  
  describe "when instrument does not exist" do
    before { @face_deploy.instrument_id = 10000 }
    it { should_not be_valid }
  end

  describe "when reporter is not present" do
    before { @face_deploy.reporter = nil }
    it { should_not be_valid }
  end
  
  describe "when reporter does not exist" do
    before { @face_deploy.reporter_id = 10000 }
    it { should_not be_valid }
  end
end

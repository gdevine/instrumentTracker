require 'spec_helper'

describe Storage do
  let(:user1) {FactoryGirl.create(:user) }
  
  before do
    @instrument = FactoryGirl.create(:instrument)
    @instrument.users << user1
    @instrument.save
    @storage = FactoryGirl.build(:storage, instrument_id:@instrument.id, reporter_id:user1.id)
  end
  
  subject { @storage }
  
  it { should respond_to(:id) }
  it { should respond_to(:startdate) }
  it { should respond_to(:comments) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:instrument) }
  it { should respond_to(:reporter_id) }
  it { should respond_to(:reporter) }
  it { should respond_to(:status_type) }
  it { should respond_to(:storage_location) }
 
  it { should be_valid }
  
  describe "when startdate is not present" do
    before { @storage.startdate = nil }
    it { should_not be_valid }
  end

  describe "when storage_location is not present" do
    before { @storage.storage_location = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not present" do
    before { @storage.status_type = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not 'Storage'" do
    before { @storage.status_type = 'nonstatus' }
    it { should_not be_valid }
  end
  
  describe "when instrument is not present" do
    before do 
      @storage.instrument = nil
    end
    it { should_not be_valid }
  end
  
  describe "when instrument does not exist" do
    before { @storage.instrument_id = 10000 }
    it { should_not be_valid }
  end

  describe "when reporter is not present" do
    before { @storage.reporter = nil }
    it { should_not be_valid }
  end
  
  describe "when reporter does not exist" do
    before { @storage.reporter_id = 10000 }
    it { should_not be_valid }
  end
end

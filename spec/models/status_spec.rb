require 'spec_helper'

describe Status do
  let(:user1) {FactoryGirl.create(:user) }
  
  before do
    @instrument = FactoryGirl.create(:instrument)
    @instrument.users << user1
    @instrument.save
    @status = FactoryGirl.build(:status, instrument_id:@instrument.id, reporter_id:user1.id)
  end
  
  subject { @status }
  
  it { should respond_to(:id) }
  it { should respond_to(:startdate) }
  it { should respond_to(:comments) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:instrument) }
  it { should respond_to(:current) }
  it { should respond_to(:reporter_id) }
  it { should respond_to(:reporter) }
  it { should respond_to(:status_type) }
 
  it { should be_valid }
  
  describe "when startdate is not present" do
    before { @status.startdate = nil }
    it { should_not be_valid }
  end
  
  describe "when current is not present" do
    before { @status.current = nil }
    it { should_not be_valid }
  end
  
  describe "when statustype is not present" do
    before { @status.status_type = nil }
    it { should_not be_valid }
  end
  
  describe "when instrument is not present" do
    before do 
      @status.instrument = nil
    end
    it { should_not be_valid }
  end
  
  describe "when instrument does not exist" do
    before { @status.instrument_id = 10000 }
    it { should_not be_valid }
  end

  describe "when reporter is not present" do
    before { @status.reporter = nil }
    it { should_not be_valid }
  end
  
  describe "when reporter does not exist" do
    before { @status.reporter_id = 10000 }
    it { should_not be_valid }
  end
  
end
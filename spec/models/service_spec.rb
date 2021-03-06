require 'spec_helper'

describe Service do
  let(:user1) {FactoryGirl.create(:user) }
  let(:user2) {FactoryGirl.create(:user) }
  
  before do
    @instrument = FactoryGirl.create(:instrument)
    @instrument.users << user1
    @instrument.save
    @service = FactoryGirl.build(:service, instrument_id:@instrument.id, reporter:user1)
  end
  
  subject { @service }
  
  it { should respond_to(:id) }
  it { should respond_to(:problem) }
  it { should respond_to(:comments) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:instrument) }
  it { should respond_to(:startdatetime) }
  it { should respond_to(:enddatetime) }
  it { should respond_to(:reporteddate) }
  it { should respond_to(:reporter_id) }
  it { should respond_to(:reporter) }
 
  it { should be_valid }
  
  describe "when startdatetime is not present" do
    before { @service.startdatetime = nil }
    it { should_not be_valid }
  end
  
  describe "when problem is not present" do
    before { @service.problem = nil }
    it { should_not be_valid }
  end
  
  describe "when instrument is not present" do
    before do 
      @service.instrument = nil
    end
    it { should_not be_valid }
  end
  
  describe "when instrument does not exist" do
    before { @service.instrument_id = 10000 }
    it { should_not be_valid }
  end

  describe "when reporter is not present" do
    before { @service.reporter = nil }
    it { should_not be_valid }
  end
  
  describe "when reporter does not exist" do
    before { @service.reporter_id = 10000 }
    it { should_not be_valid }
  end

end

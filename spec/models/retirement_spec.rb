require 'spec_helper'

describe Retirement do
  let(:user1) {FactoryGirl.create(:user) }
  
  before do
    @instrument = FactoryGirl.create(:instrument)
    @instrument.users << user1
    @instrument.save
    @retirement = FactoryGirl.build(:retirement, instrument_id:@instrument.id, reporter_id:user1.id)
  end
  
  subject { @retirement }
  
  it { should respond_to(:id) }
  it { should respond_to(:startdate) }
  it { should respond_to(:comments) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:instrument) }
  it { should respond_to(:reporter_id) }
  it { should respond_to(:reporter) }
  it { should respond_to(:status_type) }
 
  it { should be_valid }
  
  
  describe "when status_type is not present" do
    before { @retirement.status_type = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not 'Loan'" do
    before { @retirement.status_type = 'nonstatus' }
    it { should_not be_valid }
  end
  
  describe "when instrument is not present" do
    before do 
      @retirement.instrument = nil
    end
    it { should_not be_valid }
  end
  
  describe "when instrument does not exist" do
    before { @retirement.instrument_id = 10000 }
    it { should_not be_valid }
  end

  describe "when reporter is not present" do
    before { @retirement.reporter = nil }
    it { should_not be_valid }
  end
  
  describe "when reporter does not exist" do
    before { @retirement.reporter_id = 10000 }
    it { should_not be_valid }
  end
  
  describe "should allow only one retirement status per instrument" do
    before do
      @retirement2 = FactoryGirl.create(:retirement, instrument_id:@instrument.id, reporter_id:user1.id)
    end 
    
    it { should_not be_valid }
  end
    
  describe "should not have other statuses ahead of a retired instrument date" do
    before do
      @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, startdate: 2.days.ago )
      @retirement.startdate = 3.days.ago
    end 
    
    it { should_not be_valid }
  end
  
end

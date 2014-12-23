require 'spec_helper'

describe Loan do
  let(:user1) {FactoryGirl.create(:user) }
  
  before do
    @instrument = FactoryGirl.create(:instrument)
    @instrument.users << user1
    @instrument.save
    @loan = FactoryGirl.build(:loan, instrument_id:@instrument.id, reporter_id:user1.id)
  end
  
  subject { @loan }
  
  it { should respond_to(:id) }
  it { should respond_to(:startdate) }
  it { should respond_to(:comments) }
  it { should respond_to(:instrument_id) }
  it { should respond_to(:instrument) }
  it { should respond_to(:reporter_id) }
  it { should respond_to(:reporter) }
  it { should respond_to(:status_type) }
  it { should respond_to(:loaned_to) }
 
  it { should be_valid }
  
  describe "when startdate is not present" do
    before { @loan.startdate = nil }
    it { should_not be_valid }
  end

  describe "when loaned_to is not present" do
    before { @loan.loaned_to = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not present" do
    before { @loan.status_type = nil }
    it { should_not be_valid }
  end
  
  describe "when status_type is not 'Loan'" do
    before { @loan.status_type = 'nonstatus' }
    it { should_not be_valid }
  end
  
  describe "when instrument is not present" do
    before do 
      @loan.instrument = nil
    end
    it { should_not be_valid }
  end
  
  describe "when instrument does not exist" do
    before { @loan.instrument_id = 10000 }
    it { should_not be_valid }
  end

  describe "when reporter is not present" do
    before { @loan.reporter = nil }
    it { should_not be_valid }
  end
  
  describe "when reporter does not exist" do
    before { @loan.reporter_id = 10000 }
    it { should_not be_valid }
  end
end

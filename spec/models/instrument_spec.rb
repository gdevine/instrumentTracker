require 'spec_helper'

describe Instrument do

  # let(:inst) { FactoryGirl.create(:instrument) }
  
  before { @inst = FactoryGirl.build(:instrument) }
  
  subject { @inst }
  
  it { should respond_to(:id) }
  it { should respond_to(:users) }
  it { should respond_to(:model_id) }
  it { should respond_to(:serialNumber) }
  it { should respond_to(:assetNumber) }
  it { should respond_to(:purchaseDate) }
  it { should respond_to(:retirementDate) }
  it { should respond_to(:fundingSource) }
  it { should respond_to(:supplier) }
  it { should respond_to(:price) }
 
  it { should be_valid }

  describe "when more than three users are associated" do
    before do 
      @inst.save
      for i in 0..3
        @inst.users << FactoryGirl.create(:user) 
      end
    end
    
    it { should_not be_valid }
  end

  describe "when serialNumber is not present" do
    before { @inst.serialNumber = nil }
    it { should_not be_valid }
  end
  
  describe "when instrument serialNumber is not unique" do    
    before do
      inst_same_serial = @inst.dup
      inst_same_serial.save
    end
    
    it { should_not be_valid } 
  end
  
  describe "user associations" do  
    let!(:user_c) {FactoryGirl.create(:user, surname: 'clarke')}
    let!(:user_a) {FactoryGirl.create(:user, surname: 'abbot')}
    let!(:user_b) {FactoryGirl.create(:user, surname: 'brown')}
    
    before do 
      @inst.save
      @inst.users << user_b
      @inst.users << user_c
      @inst.users << user_a
    end
       
    it "should have associated users in alphabetical surname order" do
      expect(@inst.users.to_a).to eq [user_a, user_b, user_c]
    end
  end
  
end
require 'spec_helper'

describe Instrument do
  
  let(:mod) { FactoryGirl.create(:model) }
  before { @inst = FactoryGirl.build(:instrument, model_id:mod.id) }
  
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
  it { should respond_to(:services) }
  
  it { should respond_to(:model) }
 
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
  
  describe "when assetNumber is not present" do
    before { @inst.assetNumber = nil }
    it { should_not be_valid }
  end
  
  describe "when model association is not present" do
    before { @inst.model = nil }
    it { should_not be_valid }
  end
  
  describe "when instrument model/serialNumber combination is not unique" do    
    before do
      inst_same_modelserial = @inst.dup
      inst_same_modelserial.save
    end
    
    it { should_not be_valid } 
  end
  
  describe "when instrument serialNumber is the same between different models" do    
    
    let(:newmod) { FactoryGirl.create(:model) }
    before do
      inst_same_modelserial = @inst.dup
      inst_same_modelserial.model = newmod 
      inst_same_modelserial.save
    end
    
    it { should be_valid } 
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
  
  
  describe "service associations" do
    before { @inst.save }
    
    let!(:older_service) do
      FactoryGirl.create(:service, instrument: @inst, created_at: 2.days.ago)
    end
    
    let!(:newer_service) do 
      FactoryGirl.create(:service, instrument: @inst, created_at: 1.hour.ago)
    end
    
    let!(:middle_service) do 
      FactoryGirl.create(:service, instrument: @inst, created_at: 1.day.ago)
    end    
    
    it "should have the right services in the right order" do
      expect(Instrument.find_by(id:@inst.id).services.to_a).to eq [newer_service, middle_service, older_service]
    end
    
  end
  
end
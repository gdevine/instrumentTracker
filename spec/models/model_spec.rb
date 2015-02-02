require 'spec_helper'

describe Model do
  
  before { @mod = FactoryGirl.build(:model) }
  
  subject { @mod }
  
  it { should respond_to(:id) }
  it { should respond_to(:instrument_type) }
  it { should respond_to(:manufacturer) }
  it { should respond_to(:name) }
  it { should respond_to(:instruments) }
 
  it { should be_valid }
  
  describe "when modelType is not present" do
    before { @mod.instrument_type = nil }
    it { should_not be_valid }
  end
  
  describe "when manufacturer is not present" do
    before { @mod.manufacturer = nil }
    it { should_not be_valid }
  end
  
  describe "when modelName is not present" do
    before { @mod.name = nil }
    it { should_not be_valid }
  end
  
  describe "when model manufacturer/name combination is not unique" do    
    before do
      mod_same_manname = @mod.dup
      mod_same_manname.save
    end
    
    it { should_not be_valid } 
  end

end

require 'spec_helper'

describe InstrumentType do
  
  before { @it = FactoryGirl.build(:instrument_type) }
  
  subject { @it }
  
  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:details) }
  it { should respond_to(:models) }
 
  it { should be_valid }
  
  
  describe "when name is not present" do
    before { @it.name = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not unique" do    
    before do
      it_same_manname = @it.dup
      it_same_manname.save
    end
    
    it { should_not be_valid } 
  end
  
end

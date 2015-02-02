require 'spec_helper'

describe Manufacturer do
  
  before { @man = FactoryGirl.build(:manufacturer) }
  
  subject { @man }
  
  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:details) }
  it { should respond_to(:models) }
 
  it { should be_valid }
  
end

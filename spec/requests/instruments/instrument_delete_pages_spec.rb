require 'spec_helper'


describe "instrument pages:" do

  subject { page }
  
  let(:technician) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  
  describe "instrument destruction by technician" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << technician
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(technician) 
        visit instrument_path(@instrument)
      end   
      it "should delete" do
        expect { click_link "Delete Instrument" }.to change(Instrument, :count).by(-1)
      end
    end
  end
   
   
  describe "instrument destruction by admin" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(admin) 
        visit instrument_path(@instrument)
      end   
      it "should delete" do
        expect { click_link "Delete Instrument" }.to change(Instrument, :count).by(-1)
      end
    end
  end

end
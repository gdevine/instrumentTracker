require 'spec_helper'


describe "instrument pages:" do

  subject { page }  
  let(:technician) { FactoryGirl.create(:user) }

  describe "edit page" do
    
    
    describe "for non signed-in users" do
      describe "should be redirected to sign-in page" do
        before do
          @instrument = FactoryGirl.create(:instrument)
          visit edit_instrument_path(@instrument)
        end
        it { should have_title('Instrument Tracker | Sign in') }
        it { should have_content("You need to sign in or sign up before continuing.") }
      end
    end 
    
    
    describe "for signed-in technicians who are not an owner" do
      
      before do 
        @instrument = FactoryGirl.create(:instrument)
        sign_in(technician) 
        visit edit_instrument_path(@instrument)
      end 
      it { should have_title('Instrument Tracker | Home') }
      it { should have_content("You are not authorized to access this page.") }
      it { should_not have_content('Edit Instrument ' + @instrument.id.to_s) }
      it { should_not have_title(full_title('Edit Instrument')) }

    end
    
    
    describe "for signed-in technicians who are an owner" do
      
      before do 
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << technician
        sign_in(technician) 
        visit edit_instrument_path(@instrument)
      end 
      it { should have_content('Edit Instrument ' + @instrument.id.to_s) }
      it { should have_content('Model') }
      it { should have_title(full_title('Edit Instrument')) }

      
      describe "with invalid serial number information" do
        
          before do
            fill_in 'instrument_serialNumber', with: ''
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
      
      describe "with invalid model choice" do
        
          before do
            find('#models').find(:xpath, 'option[1]').select_option
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content("Model is required") }
          end
  
      end
  
      describe "with valid information" do
  
        before do
          fill_in 'instrument_serialNumber'  , with: 'dummyserial'
          fill_in 'instrument_price'   , with: 678.00
        end
        
        it "should update, not add an instrument" do
          expect { click_button "Update" }.not_to change(Instrument, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('Instrument updated') }
          it { should have_title(full_title('Instrument View')) }
        end
      
      end
      
    end  
    
  end


end
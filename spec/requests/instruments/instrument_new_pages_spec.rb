require 'spec_helper'


describe "instrument pages:" do

  subject { page }

  describe "New page" do
    
    
    describe "for non signed-in users" do
      describe "should be redirected to sign-in page" do
        before { visit new_instrument_path }
        it { should have_title('Instrument Tracker | Sign in') }
        it { should have_content("You need to sign in or sign up before continuing.") }
      end
    end
    
    
    describe "for signed-in custodians should be redirected to sign-in page" do
      let(:custodian) { FactoryGirl.create(:custodian) }
      before do
        sign_in custodian
        visit new_instrument_path
      end
      it { should have_title('Instrument Tracker | Home') }
      it { should have_content("You are not authorized to access this page.") }
    end
    
    
    describe "for signed-in technicians" do
      let(:technician) { FactoryGirl.create(:user) }
      describe "with no models in the system" do
        before do 
          sign_in technician
          visit new_instrument_path
        end  
        it { should have_content("New Instruments can't be added until at least one Instrument Model is added to the system") }
        it { should have_content('Welcome to HIE Instrument Tracker') }
        it { should_not have_title(full_title('New Instrument')) }
      end
      
      describe "with models in the system" do
        let!(:mymod) { FactoryGirl.create(:model) } # Needed to make sure something appears in the dropdown
        let!(:technician2) { FactoryGirl.create(:user) }  # An additional user
        before do 
          sign_in technician
          visit new_instrument_path
        end         
        it { should have_content('New Instrument') }
        it { should have_title(full_title('New Instrument')) }
        it { should_not have_title('| Home') }
        it { should have_content('Additional Owners') }
        #only user 2 should be showing in the dropdown menu (not the creating user)
        it { should have_content(technician2.firstname+' '+technician2.surname) }
        it { should_not have_content(technician.firstname+' '+technician.surname) }
        
        describe "with invalid information" do                 
          it "should not create an instrument" do
            expect{  click_button "Submit" }.to change{Instrument.count}.by(0)
          end
        end
        
        describe "with valid information" do 
          before do
            find('#models').find(:xpath, 'option[2]').select_option
            fill_in 'instrument_assetNumber'  , with: 'dasdasdadsa'
            fill_in 'instrument_supplier'  , with: 'Dummy Supplier Inc'
            fill_in 'instrument_serialNumber', with: 'fsdfjhkds'
            fill_in 'instrument_purchaseDate', with: Date.new(2012, 12, 3)
            fill_in 'instrument_price', with: 2430.00
          end
          
          it "should create a instrument" do
            expect { click_button "Submit" }.to change{Instrument.count}.by(1)
          end        
          
          describe "should revert to instrument view page" do
            before { click_button "Submit" }
            it { should have_content('Instrument created!') }
            it { should have_title(full_title('Instrument View')) }  
            it { should have_selector('h2', "Instrument") }
          end
          
          describe "including an additional owner" do
            before do 
              find('#users').find(:xpath, 'option[1]').select_option
            end 
            
            it "should create a instrument" do
              expect { click_button "Submit" }.to change{Instrument.count}.by(1)
            end    
            
            describe "should revert to instrument view page" do
              before { click_button "Submit" }         
              it { should have_content('Instrument created!') }
              it { should have_title(full_title('Instrument View')) }  
              it { should have_selector('h2', "Instrument") }
            end
          end
          
        end  
        
      end
    end
    
    
    describe "for signed-in admins" do
      let(:admin) { FactoryGirl.create(:admin) }
      describe "with no models in the system" do
        before do 
          sign_in admin
          visit new_instrument_path
        end  
        it { should have_content("New Instruments can't be added until at least one Instrument Model is added to the system") }
        it { should have_content('Welcome to HIE Instrument Tracker') }
        it { should_not have_title(full_title('New Instrument')) }
      end
      
      describe "with models in the system" do
        let!(:mymod) { FactoryGirl.create(:model) } # Needed to make sure something appears in the dropdown
        let!(:technician2) { FactoryGirl.create(:user) }  # An additional user
        before do 
          sign_in admin
          visit new_instrument_path
        end         
        it { should have_content('New Instrument') }
        it { should have_title(full_title('New Instrument')) }
        it { should_not have_title('| Home') }
        it { should have_content('Additional Owners') }
        #only user 2 should be showing in the dropdown menu (not the creating user)
        it { should have_content(technician2.firstname+' '+technician2.surname) }
        it { should_not have_content(admin.firstname+' '+admin.surname) }
        
        describe "with invalid information" do                 
          it "should not create an instrument" do
            expect{  click_button "Submit" }.to change{Instrument.count}.by(0)
          end
        end
        
        describe "with valid information" do 
          before do
            find('#models').find(:xpath, 'option[2]').select_option
            fill_in 'instrument_assetNumber'  , with: 'dasdasdadsa'
            fill_in 'instrument_supplier'  , with: 'Dummy Supplier Inc'
            fill_in 'instrument_serialNumber', with: 'fsdfjhkds'
            fill_in 'instrument_purchaseDate', with: Date.new(2012, 12, 3)
            fill_in 'instrument_price', with: 2430.00
          end
          
          it "should create a instrument" do
            expect { click_button "Submit" }.to change{Instrument.count}.by(1)
          end        
          
          describe "should revert to instrument view page" do
            before { click_button "Submit" }
            it { should have_content('Instrument created!') }
            it { should have_title(full_title('Instrument View')) }  
            it { should have_selector('h2', "Instrument") }
          end
          
          describe "including an additional owner" do
            before do 
              find('#users').find(:xpath, 'option[1]').select_option
            end 
            
            it "should create a instrument" do
              expect { click_button "Submit" }.to change{Instrument.count}.by(1)
            end    
            
            describe "should revert to instrument view page" do
              before { click_button "Submit" }         
              it { should have_content('Instrument created!') }
              it { should have_title(full_title('Instrument View')) }  
              it { should have_selector('h2', "Instrument") }
            end
          end
          
        end  
        
      end
    end    
    
   
  end

end
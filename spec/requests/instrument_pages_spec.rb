require 'spec_helper'

describe "instrument pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }

  describe "Index page" do
    
    describe "for signed-in users" do
      
      before { sign_in user }
      before { visit instruments_path }
      
      it { should have_content('Instrument List') }
      it { should have_title(full_title('Instrument List')) }
      it { should_not have_title('| Home') }
      
      describe "with no instruments in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Instruments found')
        end
      end
      
      describe "with instruments in the system" do
        before do
          @inst = FactoryGirl.create(:instrument)
          @user = FactoryGirl.create(:user)
          @inst.users << @user
          visit instruments_path
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Instrument ID')
        end
                   
        it "should list each instrument" do
          Instrument.paginate(page: 1).each do |inst|
            expect(page).to have_selector('table tr td', text: inst.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should be able to see instrument list" do
        before { visit instruments_path }
        it { should have_content('Instrument List') }
        it { should_not have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "New page" do
    
    describe "for signed-in users" do

      before { sign_in user }
      before { visit new_instrument_path }            
      
      it { should have_content('New Instrument') }
      it { should have_title(full_title('New Instrument')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid information" do
        
        it "should not create an instrument" do
          expect { click_button "Submit" }.not_to change(Instrument, :count)
        end
                
        before do
          click_button "Submit"
        end
        describe "should return an error" do
          it { should have_content('error') }
        end
        
      end
     
      describe "with valid information" do
        
        before do
          fill_in 'instrument_serialNumber', with: 'fsdfjhkds'
          fill_in 'instrument_supplier'  , with: 'Dummy Supplier Inc'
          fill_in 'instrument_purchaseDate', with: Date.new(2012, 12, 3)
          fill_in 'instrument_retirementDate', with: Date.new(2013, 10, 7)
          fill_in 'instrument_price', with: 2430.00
        end
        
        it "should create a instrument" do
          expect { click_button "Submit" }.to change(Instrument, :count).by(1)
        end
        
        # describe "should return to view page" do
          # before { click_button "Submit" }
          # it { should have_content('Instrument created!') }
          # it { should have_title(full_title('Instrument View')) }
        # end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_path }
        it { should have_title('Sign in') }
      end
    end
    
  end

end
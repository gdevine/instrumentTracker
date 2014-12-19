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
          @inst.users << user
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
    
    describe "for signed-in users with no models in the system should show an error" do
      before do 
        sign_in user
        visit new_instrument_path
      end         
      it { should have_content("New Instruments can't be added until at least one Instrument Model is added to the system") }
    end
    
    describe "for signed-in users with models in the system" do
      
      let!(:mymod) { FactoryGirl.create(:model) } 
      
      before do 
        sign_in user
        visit new_instrument_path
      end          
      
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
          find('#models').find(:xpath, 'option[2]').select_option
          fill_in 'instrument_assetNumber'  , with: 'dasdasdadsa'
          fill_in 'instrument_supplier'  , with: 'Dummy Supplier Inc'
          fill_in 'instrument_serialNumber', with: 'fsdfjhkds'
          fill_in 'instrument_purchaseDate', with: Date.new(2012, 12, 3)
          fill_in 'instrument_retirementDate', with: Date.new(2013, 10, 7)
          fill_in 'instrument_price', with: 2430.00
        end
        
        it "should create a instrument" do
          expect { click_button "Submit" }.to change(Instrument, :count).by(1)
        end
        
        describe "should return to view/show page" do
          before { click_button "Submit" }
          it { should have_content('Instrument created!') }
          it { should have_title(full_title('Instrument View')) }  
          it { should have_selector('h2', "Instrument") }
        end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_path }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
    end
    
    describe "for signed-in users who are an owner" do
      
      before do 
        sign_in(user) 
        visit instrument_path(@instrument)
      end
      
      let!(:page_heading) {"Instrument " + @instrument.id.to_s}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('Instrument View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Serial Number') }
      it { should have_link('Options') }
      it { should have_link('Edit Instrument') }
      it { should have_link('Delete Instrument') }
      it { should have_link('Add Service Record') }
      it { should have_link('Instrument Loan') }
      it { should have_link('Instrument Lost') }
      
      describe 'should see model details' do
        it { should have_content('Manufacturer') }
      end
      
      describe "when clicking the edit button" do
        before { click_link "Edit Instrument" }
        let!(:page_heading) {"Edit Instrument " + @instrument.id.to_s}
        
        describe 'should have a page heading for editing the correct instrument' do
          it { should have_content(page_heading) }
        end
      end 
      
      describe "when clicking the add service button" do
        before { click_link "Add Service Record" }
        let!(:page_heading) {"New Service Record for Instrument " + @instrument.id.to_s}
        
        describe 'should have a page heading for the correct service record' do
          it { should have_content(page_heading) }
        end
      end 
      
      describe "when clicking the instrument loan button" do
        before { click_link "Instrument Loan" }
        let!(:page_heading) {"New Loan Record for Instrument " + @instrument.id.to_s}
        
        describe 'should have a page heading for the correct service record' do
          it { should have_content(page_heading) }
        end
      end 
      
      describe "when clicking the instrument lost button" do
        before { click_link "Instrument Lost" }
        let!(:page_heading) {"New Lost Record for Instrument " + @instrument.id.to_s}
        
        describe 'should have a page heading for the correct service record' do
          it { should have_content(page_heading) }
        end
      end 
      
      describe "should show correct user/owner associations" do
        let!(:new_user1) { FactoryGirl.create(:user) }
        let!(:new_user2) { FactoryGirl.create(:user) }
        
        before do         
          @instrument.users << new_user1
          @instrument.users << new_user2
          visit instrument_path(@instrument)
        end
        
        it { should have_content('Contacts for this Instrument') }
        it { should have_content(user.firstname) }  
        it { should have_content(new_user1.firstname) }  
        it { should have_content(new_user2.firstname) }  
              
      end
      
      describe "should show correct services associations" do
        let!(:first_service) { FactoryGirl.create(:service, instrument_id:@instrument.id ) }
        let!(:second_service) { FactoryGirl.create(:service, instrument_id:@instrument.id ) }
        
        before do 
          visit instrument_path(@instrument)
        end
        
        it { should have_content('Service History for this Instrument') }
        it { should have_selector('table tr th', text: 'Service ID') } 
        it { should have_selector('table tr td', text: first_service.id) } 
        it { should have_selector('table tr td', text: second_service.id) }             
      end
      
      
      describe "should show correct statuses associations" do
        let!(:first_status) { FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter: user ) }
        let!(:second_status) { FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter: user ) }
        
        before do 
          visit instrument_path(@instrument)
        end
        
        it { should have_content('Status History for this Instrument') }
        it { should have_selector('table tr th', text: 'ID') } 
        it { should have_selector('table tr td', text: first_status.id) } 
        it { should have_selector('table tr td', text: second_status.id) }             
      end
      
    end
    
    describe "who don't own the current container" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit instrument_path(@instrument)
       end 
       
       let!(:page_heading) {"Instrument " + @instrument.id.to_s}
        
       describe 'should have a page heading for the correct instrument' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see model details' do
          it { should have_content('Manufacturer') }
       end
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Edit Container') }
         it { should_not have_link('Delete Container') }
       end 
       
       describe "should show correct services associations" do
        let!(:first_service) { FactoryGirl.create(:service, instrument_id:@instrument.id ) }
        let!(:second_service) { FactoryGirl.create(:service, instrument_id:@instrument.id ) }
        
        before do 
          visit instrument_path(@instrument)
        end
        
        it { should have_content('Service History for this Instrument') }
        it { should have_selector('table tr th', text: 'Service ID') } 
        it { should have_selector('table tr td', text: first_service.id) } 
        it { should have_selector('table tr td', text: second_service.id) } 
              
      end
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button be redirected back to signin" do
        before do 
         visit instrument_path(@instrument)
        end 
        
        let!(:page_heading) {"Instrument " + @instrument.id.to_s}
        
        describe 'should have a page heading for the correct instrument' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see model details' do
          it { should have_content('Manufacturer') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Edit Container') }
          it { should_not have_link('Delete Container') }
        end 
        
        describe "should show correct services associations" do
          let!(:first_service) { FactoryGirl.create(:service, instrument_id:@instrument.id ) }
          let!(:second_service) { FactoryGirl.create(:service, instrument_id:@instrument.id ) }
          
          before do 
            visit instrument_path(@instrument)
          end
          
          it { should have_content('Service History for this Instrument') }
          it { should have_selector('table tr th', text: 'Service ID') } 
          it { should have_selector('table tr td', text: first_service.id) } 
          it { should have_selector('table tr td', text: second_service.id) } 
                
        end
        
      end
    end
    
  end
  
  
  describe "edit page" do
    
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
    end 
    
    describe "for signed-in users who are an owner" do
      
      let!(:mymod) { FactoryGirl.create(:model) } 
      
      before do 
        sign_in(user) 
        visit edit_instrument_path(@instrument)
      end 
      
      it { should have_content('Edit Instrument ' + @instrument.id.to_s) }
      it { should have_title(full_title('Edit Instrument')) }
      it { should_not have_title('| Home') }
      
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
            it { should have_content("Model can't be blank") }
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
    
    describe "for signed-in users who are not an owner" do
      let(:non_owner) { FactoryGirl.create(:user) }
      before do 
        sign_in(non_owner)
        visit edit_instrument_path(@instrument)
      end 
      
      describe 'should have a page heading for the correct instrument' do
        it { should_not have_content('Edit') }
        it { should have_title('Home') }
        it { should have_content('Welcome to HIE Instrument Tracker') }
      end
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_instrument_path(@instrument) }
        it { should have_title('Sign in') }
      end
    end
  end
  
  
  describe "instrument destruction" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(user) 
        visit instrument_path(@instrument)
      end   
      it "should delete" do
        expect { click_link "Delete Instrument" }.to change(Instrument, :count).by(-1)
      end
    end
  end

end
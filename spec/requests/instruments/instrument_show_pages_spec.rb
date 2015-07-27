require 'spec_helper'


describe "instrument pages:" do

  subject { page }
  
  describe "Show page" do
    
    describe "for non signed-in users" do
      describe "should show the instrument details" do
        before do
          @instrument =  FactoryGirl.create(:instrument)
          @randomuser = FactoryGirl.create(:user)
          @instrument.users << @randomuser
          visit instrument_path(@instrument)
        end
        
        let!(:page_heading) {"Instrument " + @instrument.id.to_s}
        it { should have_selector('h2', :text => page_heading) }
        it { should have_title(full_title('Instrument View')) }
        it { should_not have_title('| Home') }  
        it { should have_content('Serial Number') }
        it { should have_content('Manufacturer') }
        it { should_not have_link('Options') }
        it { should_not have_link('Edit Instrument') }
        it { should_not have_link('Delete Instrument') }
        it { should_not have_link('Add Service Record') }
        it { should_not have_link('Instrument Loan') }
        it { should_not have_link('Instrument Lost') }
        it { should_not have_link('Instrument Storage') }
        it { should_not have_link('FACE Deployment') }
        
        
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

    
    describe "for signed-in users (across different roles)" do
        
      users = [FactoryGirl.create(:user),  FactoryGirl.create(:custodian),  FactoryGirl.create(:admin)]
      users.each do |user|
        describe "should show basic details about the instrument when not an owner/associate" do
          before do 
            @instrument =  FactoryGirl.create(:instrument)
            sign_in user
            visit instrument_path(@instrument)
          end

          let!(:page_heading) {"Instrument " + @instrument.id.to_s}
          it { should have_selector('h2', :text => page_heading) }
          it { should have_title(full_title('Instrument View')) }
          it { should_not have_title('| Home') }  
          it { should have_content('Serial Number') }
          it { should have_content('None assigned') }
          
          describe 'should see model details' do
            it { should have_content('Manufacturer') }
          end
          
          describe 'should see current status' do
            it { should have_content('Current Status') }
          end
          
          describe 'should have correct current status details' do
            let!(:newest_status) { FactoryGirl.create(:lost, startdate:Date.today, instrument:@instrument) }
            
            before { visit instrument_path(@instrument) }
            
            it { should have_content('Lost') }
            it { should have_content('View Details') }
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
            it { should have_content(new_user1.firstname) }  
            it { should have_content(new_user2.firstname) }  
            it { should_not have_content(user.firstname) }  
                  
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
            let!(:first_status) { FactoryGirl.create(:loan, instrument_id:@instrument.id ) }
            let!(:second_status) { FactoryGirl.create(:lost, instrument_id:@instrument.id ) }
            let!(:third_status) { FactoryGirl.create(:facedeployment, instrument_id:@instrument.id ) }
            # let!(:third_status) { FactoryGirl.create(:facedeployment, instrument_id:@instrument.id, reporter: user ) }
            
            before do 
              visit instrument_path(@instrument)
            end
            
            it { should have_content('Status History for this Instrument') }
            it { should have_selector('table tr th', text: 'ID') } 
            it { should have_selector('table tr td', text: first_status.id) } 
            it { should have_selector('table tr td', text: second_status.id) }             
            it { should have_selector('table tr td', text: third_status.id) }             
          end
          
        end
       
      end
     
    end
    
    
    describe "for signed-in technicians who don't own the instrument" do
       
      describe "should not show options for editing and statuses" do
        before do 
          @instrument =  FactoryGirl.create(:instrument)
          @tech = FactoryGirl.create(:user)      
          sign_in @tech
          visit instrument_path(@instrument)
        end
                  
        it { should_not have_link('Options') }
        it { should_not have_link('Edit Instrument') }
        it { should_not have_link('Add Service Record') }
        it { should_not have_link('Instrument Loan') }
        it { should_not have_link('Instrument Lost') }
        it { should_not have_link('Instrument Storage') }
        it { should_not have_link('FACE Deployment') }

      end
    end
        
    
    describe "for signed-in technicians who own the instrument" do
       
      describe "should show options for editing and statuses" do
        before do 
          @instrument =  FactoryGirl.create(:instrument)
          @tech = FactoryGirl.create(:user)      
          @instrument.users << @tech
          sign_in @tech
          visit instrument_path(@instrument)
        end
                  
        it { should have_link('Options') }
        it { should have_link('Edit Instrument') }
        it { should have_link('Add Service Record') }
        it { should have_link('Instrument Loan') }
        it { should have_link('Instrument Lost') }
        it { should have_link('Instrument Storage') }
        it { should have_link('FACE Deployment') }

        
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
   
        describe "when clicking the face deployment button" do
          before { click_link "FACE Deployment" }
          let!(:page_heading) {"New FACE Deployment Record for Instrument " + @instrument.id.to_s}
          
          describe 'should have a page heading for the correct service record' do
            it { should have_content(page_heading) }
          end
        end 
   
        describe "when clicking the storage button" do
          before { click_link "Instrument Storage" }
          let!(:page_heading) {"New In Storage Record for Instrument " + @instrument.id.to_s}
          
          describe 'should have a page heading for the correct status record' do
            it { should have_content(page_heading) }
          end
        end 
  
      end
        
    end

    
    describe "for signed-in custodians who don't own the instrument" do
       
      describe "should not show options for editing and statuses" do
        before do 
          @instrument =  FactoryGirl.create(:instrument)
          @custodian = FactoryGirl.create(:custodian)      
          sign_in @custodian
          visit instrument_path(@instrument)
        end
                  
        it { should_not have_link('Options') }
        it { should_not have_link('Edit Instrument') }
        it { should_not have_link('Add Service Record') }
        it { should_not have_link('Instrument Loan') }
        it { should_not have_link('Instrument Lost') }
        it { should_not have_link('Instrument Storage') }
        it { should_not have_link('FACE Deployment') }

      end
    end
            

    describe "for signed-in custodians who own the instrument" do
       
      describe "should show options for editing and statuses" do
        before do 
          @instrument =  FactoryGirl.create(:instrument)
          @custodian = FactoryGirl.create(:custodian)      
          @instrument.users << @custodian
          sign_in @custodian
          visit instrument_path(@instrument)
        end
                  
        it { should have_link('Options') }
        it { should have_link('Edit Instrument') }
        it { should have_link('Add Service Record') }
        it { should have_link('Instrument Loan') }
        it { should have_link('Instrument Lost') }
        it { should have_link('Instrument Storage') }
        it { should have_link('FACE Deployment') }

        
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
   
        describe "when clicking the face deployment button" do
          before { click_link "FACE Deployment" }
          let!(:page_heading) {"New FACE Deployment Record for Instrument " + @instrument.id.to_s}
          
          describe 'should have a page heading for the correct service record' do
            it { should have_content(page_heading) }
          end
        end 
   
        describe "when clicking the storage button" do
          before { click_link "Instrument Storage" }
          let!(:page_heading) {"New In Storage Record for Instrument " + @instrument.id.to_s}
          
          describe 'should have a page heading for the correct status record' do
            it { should have_content(page_heading) }
          end
        end 
  
      end
        
    end
    
    
    describe "for signed-in admins" do
       
      describe "should show options for editing and statuses" do
        before do 
          @instrument =  FactoryGirl.create(:instrument)
          @admin = FactoryGirl.create(:admin)      
          sign_in @admin
          visit instrument_path(@instrument)
        end
                  
        it { should have_link('Options') }
        it { should have_link('Edit Instrument') }
        it { should have_link('Add Service Record') }
        it { should have_link('Instrument Loan') }
        it { should have_link('Instrument Lost') }
        it { should have_link('Instrument Storage') }
        it { should have_link('FACE Deployment') }

        
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
   
        describe "when clicking the face deployment button" do
          before { click_link "FACE Deployment" }
          let!(:page_heading) {"New FACE Deployment Record for Instrument " + @instrument.id.to_s}
          
          describe 'should have a page heading for the correct service record' do
            it { should have_content(page_heading) }
          end
        end 
   
        describe "when clicking the storage button" do
          before { click_link "Instrument Storage" }
          let!(:page_heading) {"New In Storage Record for Instrument " + @instrument.id.to_s}
          
          describe 'should have a page heading for the correct status record' do
            it { should have_content(page_heading) }
          end
        end 
  
      end
        
    end

   
  end

end
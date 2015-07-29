require 'spec_helper'

describe "Deployment pages:" do

  subject { page }
  
  let(:technician) { FactoryGirl.create(:user) }
  let!(:site1) { FactoryGirl.create(:site) } 
  
  describe "Index page per instrument" do
    
    describe "for signed-in technicians" do
      
      before do 
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << technician
        @instrument.save  
        sign_in technician
        visit instrument_deployments_path(@instrument)
      end
      
      it { should have_content('Deployment List for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('Deployment List')) }
      it { should_not have_title('| Home') }
      
      describe "with no deployments in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Records found')
        end
      end
      
      describe "with deployment records in the system" do
        before do    
          @deployment = FactoryGirl.create(:deployment, instrument_id:@instrument.id, reporter:technician)
          visit instrument_deployments_path(@instrument)
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Status ID')
        end
                   
        it "should list each deployment record" do
          Deployment.paginate(page: 1).each do |deployment|
            expect(page).to have_selector('table tr td', text: @deployment.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should not be able to see instrument deployment list" do
        before do
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << technician
          @instrument.save
          @deployment = FactoryGirl.create(:deployment, instrument_id:@instrument.id, reporter:technician)
          visit instrument_deployments_path(@instrument)
        end
        
        it { should have_content('Deployment List for Instrument '+@instrument.id.to_s) }
        it { should_not have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "New page" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << technician
      @instrument.save  
    end
    
    describe "for signed-in users creating a deployment record" do
      
      before do 
        sign_in technician
        visit new_instrument_deployment_path(instrument_id:@instrument.id)
      end          
      
      it { should have_content('New Deployment Record for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('New Deployment Record')) }
      it { should_not have_title('| Home') }
      it { should have_content('Deployment') }
      it { should have_content('Comments') }
      
      describe "with invalid information" do
        
        it "should not create a deployment Record" do
          expect { click_button "Submit" }.not_to change(Status, :count)
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
          fill_in 'deployment_startdate', with: Date.new(2012, 12, 3)
          find('#sites').find(:xpath, 'option[2]').select_option
        end
        
        it "should create a status" do
          expect { click_button "Submit" }.to change(Status, :count).by(1)
        end
        
        describe "should return to Instrument page" do
          before { click_button "Submit" }
          it { should have_content('Deployment Record Created!') }
          it { should have_title(full_title('Deployment Record View')) }  
          it { should have_selector('h2', "Instrument "+ @instrument.id.to_s) }
        end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_deployment_path(instrument_id:@instrument.id) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << technician
      @instrument.save  
      @deployment = FactoryGirl.create(:deployment, instrument_id:@instrument.id, reporter:technician)
    end
    
    describe "for signed-in users who are an owner on a deployment record" do
      
      before do 
        sign_in(technician) 
        visit deployment_path(@deployment)
      end
      
      let!(:page_heading) {"Deployment Record"}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('Deployment Record View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Site') }
      it { should have_content('Reported by') }
      it { should have_link('Options') }
      it { should have_link('Edit Deployment Record') }
      it { should have_link('Delete Deployment Record') }
      it { should have_link('View Instrument') }
      
      describe 'should see Instrument details' do
        it { should have_content('Instrument Serial Number') }
       end
      
      describe "when clicking the edit button" do
        before { click_link "Edit Deployment Record" }
        let!(:page_heading) {"Edit Deployment Record " + @deployment.id.to_s + ' for Instrument '+@instrument.id.to_s}
        
        describe 'should have a page heading for editing the correct deployment record' do
          it { should have_content(page_heading) }
        end
      end 
      
    end
    
    describe "for signed in technicians who don't own the current deployed instrument" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit deployment_path(@deployment)
       end 
       
       let!(:page_heading) {"Deployment Record"}
        
       describe 'should have a page heading for the correct deployment' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
       end
       
       describe 'should see site' do
          it { should have_content('Site') }
       end       
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Options') }
         it { should_not have_link('Edit Deployment Record') }
         it { should_not have_link('Delete Deployment Record') }
       end 
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button" do
        before do 
          visit deployment_path(id:@deployment.id)
        end 
        
        let!(:page_heading) {"Instrument Deployment Record"}
        
        describe 'should have a page heading for the correct deployment' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Options') }
          it { should_not have_link('Edit Deployment Record') }
          it { should_not have_link('Delete Deployment Record') }
        end 
      end
    end
    
  end
  
  
  describe "edit page" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << technician
      @instrument.save  
      @deployment = FactoryGirl.create(:deployment, instrument_id:@instrument.id, reporter:technician)
    end 
    
    describe "for signed-in users who are an owner of the instrument" do
      
      before do 
        sign_in(technician) 
        visit edit_deployment_path(@deployment)
      end 
      
      it { should have_content('Edit Deployment Record ' + @deployment.id.to_s + ' for Instrument '+ @instrument.id.to_s) }
      it { should have_title(full_title('Edit Deployment Record')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid site information" do
        
          before do
            find('#sites').find(:xpath, 'option[normalize-space(.)="None selected"]').select_option
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
  
      describe "with valid information" do
  
        before do
          find('#sites').find(:xpath, 'option[2]').select_option
        end
        
        it "should update, not add a status" do
          expect { click_button "Update" }.not_to change(Status, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('Deployment Record Updated') }
          it { should have_title(full_title('Deployment Record View')) }
        end
      
      end
      
    end  
    
    describe "for signed-in technicians who are not an owner" do
      let(:non_owner) { FactoryGirl.create(:user) }
      before do 
        sign_in(non_owner)
        visit edit_deployment_path(@deployment)
      end 
      
      describe 'should redirect to home page' do
        it { should_not have_content('Edit') }
        it { should have_title('Home') }
        it { should have_content('Welcome to HIE Instrument Tracker') }
      end
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_deployment_path(@deployment) }
        it { should have_title('Sign in') }
      end
    end
  end
  
  
  describe "Deployment destruction" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << technician
      @instrument.save 
      @deployment = FactoryGirl.create(:deployment, instrument_id:@instrument.id, reporter:technician)
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(technician) 
        visit deployment_path(@deployment)
      end   
      
      it "should delete" do
        expect { click_link "Delete Deployment Record" }.to change(Status, :count).by(-1)
      end
      
      describe "should return to view page" do
        before { click_link "Delete Deployment Record" }
        it { should have_content('Deployment Record Deleted') }
        it { should have_title(full_title('Instrument View')) }
      end
    end
  end
  

end
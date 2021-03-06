require 'spec_helper'

describe "FACE Deployment pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "Index page per instrument" do
    
    describe "for signed-in users" do
      
      before do 
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << user
        @instrument.save  
        sign_in user
        visit instrument_facedeployments_path(@instrument)
      end
      
      it { should have_content('FACE Deployment List for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('FACE Deployment List')) }
      it { should_not have_title('| Home') }
      
      describe "with no face deployment records in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Records found')
        end
      end
      
      describe "with face deployment records in the system" do
        before do    
          @facedeployment = FactoryGirl.create(:facedeployment, instrument_id:@instrument.id, reporter:user)
          visit instrument_facedeployments_path(@instrument)
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Status ID')
        end
                   
        it "should list each face deployment record" do
          Facedeployment.paginate(page: 1).each do |facedeployment|
            expect(page).to have_selector('table tr td', text: @facedeployment.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should not be able to see instrument face deployment list" do
        before do
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << user
          @instrument.save
          @facedeployment = FactoryGirl.create(:facedeployment, instrument_id:@instrument.id, reporter:user)
          visit instrument_facedeployments_path(@instrument)
        end
        
        it { should have_content('FACE Deployment List for Instrument '+@instrument.id.to_s) }
        it { should_not have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "New page" do
              
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
    end
    
    describe "for signed-in users creating a face deployment record" do
      
      before do 
        sign_in user
        visit new_instrument_facedeployment_path(instrument_id:@instrument.id)
      end          
      
      it { should have_content('New FACE Deployment Record for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('New FACE Deployment Record')) }
      it { should_not have_title('| Home') }
      it { should have_content('Ring') }
      it { should have_content('Northing') }
      
      describe "with invalid information" do
        
        it "should not create a Face Deployment Record" do
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
          fill_in 'facedeployment_startdate', with: Date.new(2012, 12, 3)
          fill_in 'facedeployment_ring', with: 4
        end
        
        it "should create a status" do
          expect { click_button "Submit" }.to change(Status, :count).by(1)
        end
        
        describe "should return to Instrument page" do
          before { click_button "Submit" }
          it { should have_content('FACE Deployment Record Created!') }
          it { should have_title(full_title('FACE Deployment Record View')) }  
          it { should have_selector('h2', "Instrument "+ @instrument.id.to_s) }
        end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_facedeployment_path(instrument_id:@instrument.id) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @facedeployment = FactoryGirl.create(:facedeployment, instrument_id:@instrument.id, reporter:user)
    end
    
    describe "for signed-in users who are an owner on a face deployment record" do
      
      before do 
        sign_in(user) 
        visit facedeployment_path(@facedeployment)
      end
      
      let!(:page_heading) {"FACE Deployment Record"}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('FACE Deployment Record View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Ring') }
      it { should have_content('Reported by') }
      it { should have_link('Options') }
      it { should have_link('Edit FACE Deployment Record') }
      it { should have_link('Delete FACE Deployment Record') }
      it { should have_link('View Instrument') }
      
      describe 'should see Instrument details' do
        it { should have_content('Instrument Serial Number') }
       end
      
      describe "when clicking the edit button" do
        before { click_link "Edit FACE Deployment Record" }
        let!(:page_heading) {"Edit FACE Deployment Record " + @facedeployment.id.to_s + ' for Instrument '+@instrument.id.to_s}
        
        describe 'should have a page heading for editing the correct face deployment record' do
          it { should have_content(page_heading) }
        end
      end 
      
    end
    
    describe "for signed in users who don't own the current deployed instrument" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit facedeployment_path(@facedeployment)
       end 
       
       let!(:page_heading) {"FACE Deployment Record"}
        
       describe 'should have a page heading for the correct service' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
       end
       
       describe 'should see face ring' do
          it { should have_content('Ring') }
       end       
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Options') }
         it { should_not have_link('Edit FACE Deployment Record') }
         it { should_not have_link('Delete FACE Deployment Record') }
       end 
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button" do
        before do 
          visit facedeployment_path(id:@facedeployment.id)
        end 
        
        let!(:page_heading) {"Instrument FACE Deployment Record"}
        
        describe 'should have a page heading for the correct service' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Options') }
          it { should_not have_link('Edit FACE Deployment Record') }
          it { should_not have_link('Delete FACE Deployment Record') }
        end 
      end
    end
    
  end
  
  
  describe "edit page" do
    
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @facedeployment = FactoryGirl.create(:facedeployment, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner of the instrument" do
      
      before do 
        sign_in(user) 
        visit edit_facedeployment_path(@facedeployment)
      end 
      
      it { should have_content('Edit FACE Deployment Record ' + @facedeployment.id.to_s + ' for Instrument '+ @instrument.id.to_s) }
      it { should have_title(full_title('Edit FACE Deployment Record')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid ring information" do
        
          before do
            fill_in 'facedeployment_ring', with: ''
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
  
      describe "with valid information" do
  
        before do
          fill_in 'facedeployment_ring'  , with: 2
        end
        
        it "should update, not add a status" do
          expect { click_button "Update" }.not_to change(Status, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('FACE Deployment Record Updated') }
          it { should have_title(full_title('FACE Deployment Record View')) }
        end
      
      end
      
    end  
    
    describe "for signed-in users who are not an owner" do
      let(:non_owner) { FactoryGirl.create(:user) }
      before do 
        sign_in(non_owner)
        visit edit_facedeployment_path(@facedeployment)
      end 
      
      describe 'should redirect to home page' do
        it { should_not have_content('Edit') }
        it { should have_title('Home') }
        it { should have_content('Welcome to HIE Instrument Tracker') }
      end
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_facedeployment_path(@facedeployment) }
        it { should have_title('Sign in') }
      end
    end
  end
  
  
  describe "Face deployment destruction" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save 
      @facedeployment = FactoryGirl.create(:facedeployment, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(user) 
        visit facedeployment_path(@facedeployment)
      end   
      
      it "should delete" do
        expect { click_link "Delete FACE Deployment Record" }.to change(Status, :count).by(-1)
      end
      
      describe "should return to view page" do
        before { click_link "Delete FACE Deployment Record" }
        it { should have_content('FACE Deployment Record Deleted') }
        it { should have_title(full_title('Instrument View')) }
      end
    end
  end
  

end
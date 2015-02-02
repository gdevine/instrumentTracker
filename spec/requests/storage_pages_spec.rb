require 'spec_helper'

describe "Storage pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "Index page per instrument" do
    
    describe "for signed-in users" do
      
      before do 
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << user
        @instrument.save  
        sign_in user
        visit instrument_storages_path(@instrument)
      end
      
      it { should have_content('In Storage List for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('In Storage List')) }
      it { should_not have_title('| Home') }
      
      describe "with no storage records in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Records found')
        end
      end
      
      describe "with storage records in the system" do
        before do    
          @storage = FactoryGirl.create(:storage, instrument_id:@instrument.id, reporter:user)
          visit instrument_storages_path(@instrument)
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Status ID')
        end
                   
        it "should list each storage record" do
          Storage.paginate(page: 1).each do |storage|
            expect(page).to have_selector('table tr td', text: @storage.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should not be able to see instrument storage list" do
        before do
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << user
          @instrument.save
          @storage = FactoryGirl.create(:storage, instrument_id:@instrument.id, reporter:user)
          visit instrument_storages_path(@instrument)
        end
        
        it { should_not have_content('Storage List for Instrument '+@instrument.id.to_s) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "New page" do
              
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
    end
    
    describe "for signed-in users creating a storage record" do
      
      before do 
        sign_in user
        visit new_instrument_storage_path(instrument_id:@instrument.id)
      end          
      
      it { should have_content('New In Storage Record for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('New In Storage Record')) }
      it { should_not have_title('| Home') }
      it { should have_content('Storage Location') }
      it { should have_content('Comments') }
      
      describe "with invalid information" do
        
        it "should not create a Storage Record" do
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
          fill_in 'storage_startdate', with: Date.new(2012, 12, 3)
          fill_in 'storage_storage_location', with: 'Room 23'
        end
        
        it "should create a status" do
          expect { click_button "Submit" }.to change(Status, :count).by(1)
        end
        
        describe "should return to Instrument page" do
          before { click_button "Submit" }
          it { should have_content('In Storage Record Created!') }
          it { should have_title(full_title('In Storage Record View')) }  
          it { should have_selector('h2', "Instrument "+ @instrument.id.to_s) }
        end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_storage_path(instrument_id:@instrument.id) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @storage = FactoryGirl.create(:storage, instrument_id:@instrument.id, reporter:user)
    end
    
    describe "for signed-in users who are an owner on a storage record" do
      
      before do 
        sign_in(user) 
        visit storage_path(@storage)
      end
      
      let!(:page_heading) {"In Storage Record"}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('In Storage Record View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Storage Location') }
      it { should have_content('Reported by') }
      it { should have_link('Options') }
      it { should have_link('Edit In Storage Record') }
      it { should have_link('Delete In Storage Record') }
      it { should have_link('View Instrument') }
      
      describe 'should see Instrument details' do
        it { should have_content('Instrument Serial Number') }
       end
      
      describe "when clicking the edit button" do
        before { click_link "Edit In Storage Record" }
        let!(:page_heading) {"Edit In Storage Record " + @storage.id.to_s + ' for Instrument '+@instrument.id.to_s}
        
        describe 'should have a page heading for editing the correct storage record' do
          it { should have_content(page_heading) }
        end
      end 
      
    end
    
    describe "for signed in users who don't own the current deployed instrument" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit storage_path(@storage)
       end 
       
       let!(:page_heading) {"In Storage Record"}
        
       describe 'should have a page heading for the correct service' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
       end
       
       describe 'should see storage location' do
          it { should have_content('Storage Location') }
       end       
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Options') }
         it { should_not have_link('Edit In Storage Record') }
         it { should_not have_link('Delete In Storage Record') }
       end 
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button" do
        before do 
          visit storage_path(id:@storage.id)
        end 
        
        let!(:page_heading) {"Instrument In Storage Record"}
        
        describe 'should have a page heading for the correct service' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Options') }
          it { should_not have_link('Edit In Storage Record') }
          it { should_not have_link('Delete In Storage Record') }
        end 
      end
    end
    
  end
  
  
  describe "edit page" do
    
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @storage = FactoryGirl.create(:storage, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner of the instrument" do
      
      before do 
        sign_in(user) 
        visit edit_storage_path(@storage)
      end 
      
      it { should have_content('Edit In Storage Record ' + @storage.id.to_s + ' for Instrument '+ @instrument.id.to_s) }
      it { should have_title(full_title('Edit In Storage Record')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid storage location information" do
        
          before do
            fill_in 'storage_storage_location', with: ''
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
  
      describe "with valid information" do
  
        before do
          fill_in 'storage_storage_location'  , with: 'Valid location'
        end
        
        it "should update, not add a status" do
          expect { click_button "Update" }.not_to change(Status, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('In Storage Record Updated') }
          it { should have_title(full_title('In Storage Record View')) }
        end
      
      end
      
    end  
    
    describe "for signed-in users who are not an owner" do
      let(:non_owner) { FactoryGirl.create(:user) }
      before do 
        sign_in(non_owner)
        visit edit_storage_path(@storage)
      end 
      
      describe 'should redirect to home page' do
        it { should_not have_content('Edit') }
        it { should have_title('Home') }
        it { should have_content('Welcome to HIE Instrument Tracker') }
      end
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_storage_path(@storage) }
        it { should have_title('Sign in') }
      end
    end
  end
  
  
  describe "Storage destruction" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save 
      @storage = FactoryGirl.create(:storage, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(user) 
        visit storage_path(@storage)
      end   
      
      it "should delete" do
        expect { click_link "Delete In Storage Record" }.to change(Status, :count).by(-1)
      end
      
      describe "should return to view page" do
        before { click_link "Delete In Storage Record" }
        it { should have_content('In Storage Record Deleted') }
        it { should have_title(full_title('Instrument View')) }
      end
    end
  end
  

end
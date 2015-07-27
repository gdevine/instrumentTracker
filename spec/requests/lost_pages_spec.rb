require 'spec_helper'

describe "Lost pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }

  describe "Index page per instrument" do
    
    describe "for signed-in users" do
      
      before do 
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << user
        @instrument.save  
        sign_in user
        visit instrument_losts_path(@instrument)
      end
      
      it { should have_content('Lost List for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('Lost List')) }
      it { should_not have_title('| Home') }
      
      describe "with no lost records in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Records found')
        end
      end
      
      describe "with lost records in the system" do
        before do    
          @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
          visit instrument_losts_path(@instrument)
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Status ID')
        end
                   
        it "should list each lost record" do
          Lost.paginate(page: 1).each do |lost|
            expect(page).to have_selector('table tr td', text: @lost.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should not be able to see instrument lost list" do
        before do
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << user
          @instrument.save
          @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
          visit instrument_losts_path(@instrument)
        end
        
        it { should have_content('Lost List for Instrument '+@instrument.id.to_s) }
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
    
    describe "for signed-in users creating a lost record" do
      
      before do 
        sign_in user
        visit new_instrument_lost_path(instrument_id:@instrument.id)
      end          
      
      it { should have_content('New Lost Record for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('New Lost Record')) }
      it { should_not have_title('| Home') }
      it { should have_content('Start Date') }
      
      describe "with invalid information" do
        
        it "should not create a Lost Record" do
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
          fill_in 'lost_startdate', with: Date.new(2012, 12, 3)
          fill_in 'lost_comments', with: 'A dummy comment'
        end
        
        it "should create a status" do
          expect { click_button "Submit" }.to change(Status, :count).by(1)
        end
        
        describe "should return to Instrument page" do
          before { click_button "Submit" }
          it { should have_content('Lost Record Created!') }
          it { should have_title(full_title('Lost Record View')) }  
          it { should have_selector('h2', "Instrument "+ @instrument.id.to_s) }
        end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_lost_path(instrument_id:@instrument.id) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
    end
    
    describe "for signed-in users who are an owner on a lost record" do
      
      before do 
        sign_in(user) 
        visit lost_path(@lost)
      end
      
      let!(:page_heading) {"Instrument Lost Record"}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('Lost Record View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Comments') }
      it { should have_content('Reported by') }
      it { should have_link('Options') }
      it { should have_link('Edit Lost Record') }
      it { should have_link('Delete Lost Record') }
      it { should have_link('View Instrument') }
      
      describe 'should see Instrument details' do
        it { should have_content('Instrument Serial Number') }
       end
      
      describe "when clicking the edit button" do
        before { click_link "Edit Lost Record" }
        let!(:page_heading) {"Edit Lost Record " + @lost.id.to_s + ' for Instrument '+@instrument.id.to_s}
        
        describe 'should have a page heading for editing the correct lost record' do
          it { should have_content(page_heading) }
        end
      end 
      
    end
    
    describe "for signed in users who don't own the current lost instrument" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit lost_path(@lost)
       end 
       
       let!(:page_heading) {"Instrument Lost Record"}
        
       describe 'should have a page heading for the correct lost record' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
       end
       
       describe 'should see status details' do
          it { should have_content('Comments') }
       end       
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Options') }
         it { should_not have_link('Edit Lost Record') }
         it { should_not have_link('Delete Lost record') }
       end 
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button" do
        before do 
          visit lost_path(id:@lost.id)
        end 
        
        let!(:page_heading) {"Instrument Lost Record"}
        
        describe 'should have a page heading for the correct lost record' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Options') }
          it { should_not have_link('Edit Lost Record') }
          it { should_not have_link('Delete Lost Record') }
        end 
      end
    end
    
  end
  
  
  describe "edit page" do
    
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner of the instrument" do
      
      before do 
        sign_in(user) 
        visit edit_lost_path(@lost)
      end 
      
      it { should have_content('Edit Lost Record ' + @lost.id.to_s + ' for Instrument '+ @instrument.id.to_s) }
      it { should have_title(full_title('Edit Lost Record')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid losted to information" do
        
          before do
            fill_in 'lost_startdate', with: ''
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
      
   
      describe "with valid information" do
        
        it "should update, not add a status" do
          expect { click_button "Update" }.not_to change(Status, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('Lost Record Updated') }
          it { should have_title(full_title('Lost Record View')) }
        end
      
      end
      
    end  
    
    describe "for signed-in users who are not an owner" do
      let(:non_owner) { FactoryGirl.create(:user) }
      before do 
        sign_in(non_owner)
        visit edit_lost_path(@lost)
      end 
      
      describe 'should have a page heading for the correct lost record' do
        it { should_not have_content('Edit') }
        it { should have_title('Home') }
        it { should have_content('Welcome to HIE Instrument Tracker') }
      end
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_lost_path(@lost) }
        it { should have_title('Sign in') }
      end
    end
  end
  
  
  describe "lost destruction" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save 
      @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(user) 
        visit lost_path(@lost)
      end   
      
      it "should delete" do
        expect { click_link "Delete Lost Record" }.to change(Status, :count).by(-1)
      end
      
      describe "should return to view page" do
        before { click_link "Delete Lost Record" }
        it { should have_content('Lost Record Deleted') }
        it { should have_title(full_title('Instrument View')) }
      end
    end
  end
  

end
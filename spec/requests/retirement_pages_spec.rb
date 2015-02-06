require 'spec_helper'

describe "Retirement pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  
  describe "New page" do
              
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
    end
    
    describe "for signed-in users retiring an instrument" do
      
      before do 
        sign_in user
        visit new_instrument_retirement_path(instrument_id:@instrument.id)
      end          
      
      it { should have_content('Retire Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('Instrument Retirement')) }
      it { should_not have_title('| Home') }
      it { should have_content('Start Date of Retirement') }
      
      describe "with invalid information" do
        
        it "should not retire an Instrument" do
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
          fill_in 'retirement_startdate', with: Date.new(2012, 12, 3)
        end
        
        it "should create a status" do
          expect { click_button "Submit" }.to change(Status, :count).by(1)
        end
        
        describe "should return to Instrument page" do
          before { click_button "Submit" }
          it { should have_content('Instrument has been retired!') }
          it { should have_title(full_title('Retired Record View')) }  
          it { should have_selector('h2', "Instrument "+ @instrument.id.to_s) }
        end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_retirement_path(instrument_id:@instrument.id) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @retirement = FactoryGirl.create(:retirement, instrument_id:@instrument.id, reporter:user)
    end
    
    describe "for signed-in users who are an owner on a retirement record" do
      
      before do 
        sign_in(user) 
        visit retirement_path(@retirement)
      end
      
      let!(:page_heading) {"Instrument Retired Record"}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('Retired Record View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Retired on') }
      it { should have_content('Reported by') }
      it { should have_link('Options') }
      it { should have_link('Edit Retired Record') }
      it { should have_link('Delete Retired Record') }
      it { should have_link('View Instrument') }
      
      describe 'should see Instrument details' do
        it { should have_content('Instrument Serial Number') }
       end
      
      describe "when clicking the edit button" do
        before { click_link "Edit Retired Record" }
        let!(:page_heading) {"Edit Retired Record " + @retirement.id.to_s + ' for Instrument '+@instrument.id.to_s}
        
        describe 'should have a page heading for editing the correct retirement record' do
          it { should have_content(page_heading) }
        end
      end 
      
    end
    
    describe "for signed in users who don't own the current retired instrument" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit retirement_path(@retirement)
       end 
       
       let!(:page_heading) {"Instrument Retired Record"}
        
       describe 'should have a page heading for the retired record' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
       end
       
       describe 'should see status details' do
          it { should have_content('Retired on') }
       end       
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Options') }
         it { should_not have_link('Edit Retired Record') }
         it { should_not have_link('Delete Retired record') }
       end 
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button" do
        before do 
          visit retirement_path(id:@retirement.id)
        end 
        
        let!(:page_heading) {"Instrument Retired Record"}
        
        describe 'should have a page heading for the correct retired record' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Options') }
          it { should_not have_link('Edit Retired Record') }
          it { should_not have_link('Delete Retired Record') }
        end 
      end
    end
    
  end
  
  
  describe "edit page" do
    
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @retirement = FactoryGirl.create(:retirement, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner of the instrument" do
      
      before do 
        sign_in(user) 
        visit edit_retirement_path(@retirement)
      end 
      
      it { should have_content('Edit Retired Record ' + @retirement.id.to_s + ' for Instrument '+ @instrument.id.to_s) }
      it { should have_title(full_title('Edit Retired Record')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid retired information" do
        
          before do
            fill_in 'retirement_startdate', with: ''
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
      
  
      describe "with valid information" do
  
        before do
          fill_in 'retirement_startdate', with: Date.new(2014, 12, 3)
        end
        
        it "should update, not add a status" do
          expect { click_button "Update" }.not_to change(Status, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('Retired Record Updated') }
          it { should have_title(full_title('Retired Record View')) }
        end
      
      end
      
    end  
    
    describe "for signed-in users who are not an owner" do
      let(:non_owner) { FactoryGirl.create(:user) }
      before do 
        sign_in(non_owner)
        visit edit_retirement_path(@retirement)
      end 
      
      describe 'should have a page heading for the correct retirement' do
        it { should_not have_content('Edit') }
        it { should have_title('Home') }
        it { should have_content('Welcome to HIE Instrument Tracker') }
      end
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_retirement_path(@retirement) }
        it { should have_title('Sign in') }
      end
    end
  end
  
  
  describe "retirement destruction" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save 
      @retirement = FactoryGirl.create(:retirement, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(user) 
        visit retirement_path(@retirement)
      end   
      
      it "should delete" do
        expect { click_link "Delete Retired Record" }.to change(Status, :count).by(-1)
      end
      
      describe "should return to view page" do
        before { click_link "Delete Retired Record" }
        it { should have_content('Retired Record Deleted') }
        it { should have_title(full_title('Instrument View')) }
      end
    end
  end
  

end
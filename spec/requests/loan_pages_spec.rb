require 'spec_helper'

describe "Loan pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "Index page per instrument" do
    
    describe "for signed-in users" do
      
      before do 
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << user
        @instrument.save  
        sign_in user
        visit instrument_loans_path(@instrument)
      end
      
      it { should have_content('Loan List for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('Loan List')) }
      it { should_not have_title('| Home') }
      
      describe "with no loan records in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Records found')
        end
      end
      
      describe "with loan records in the system" do
        before do    
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << user
          @instrument.save
          @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
          visit instrument_loans_path(@instrument)
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Status ID')
        end
                   
        it "should list each loan record" do
          Loan.paginate(page: 1).each do |loan|
            expect(page).to have_selector('table tr td', text: @loan.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should not be able to see instrument loan list" do
        before do
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << user
          @instrument.save
          @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
          visit instrument_loans_path(@instrument)
        end
        
        it { should_not have_content('Loan List for Instrument '+@instrument.id.to_s) }
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
    
    describe "for signed-in users creating a loan record" do
      
      before do 
        sign_in user
        visit new_instrument_loan_path(instrument_id:@instrument.id)
      end          
      
      it { should have_content('New Loan Record for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('New Loan Record')) }
      it { should_not have_title('| Home') }
      it { should have_content('Loaned to') }
      
      describe "with invalid information" do
        
        it "should not create a Loan Record" do
          expect { click_button "Submit" }.not_to change(Status, :count)
        end
                
        before do
          click_button "Submit"
        end
        
        describe "should return an error" do
          it { should have_content('error') }
        end
        
      end
      
      describe "with an end date before a start date" do
        
        before do
          fill_in 'loan_startdate', with: Date.new(2014, 8, 11)
          fill_in 'loan_enddate', with: Date.new(2014, 7, 11)
          fill_in 'loan_loaned_to', with: 'a dummy problem'
        end
        
        it "should not create a Loan record" do
          expect { click_button "Submit" }.not_to change(Status, :count)
        end
                
        describe "it should have a targeted error" do
          before do
            click_button "Submit"
          end
      
          describe "should return an error" do
            it { should have_content('End Date cannot precede Start Date') }
          end   
        end
        
      end
     
      describe "with valid information" do
        
        before do
          fill_in 'loan_startdate', with: Date.new(2012, 12, 3)
          fill_in 'loan_loaned_to', with: 'a dummy loanee'
        end
        
        it "should create a status" do
          expect { click_button "Submit" }.to change(Status, :count).by(1)
        end
        
        describe "should return to Instrument page" do
          before { click_button "Submit" }
          it { should have_content('Loan Record Created!') }
          it { should have_title(full_title('Loan Record View')) }  
          it { should have_selector('h2', "Instrument "+ @instrument.id.to_s) }
        end
        
      end  
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_instrument_loan_path(instrument_id:@instrument.id) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
    end
    
    describe "for signed-in users who are an owner on a loan record" do
      
      before do 
        sign_in(user) 
        visit loan_path(@loan)
      end
      
      let!(:page_heading) {"Instrument Loan Record"}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('Loan Record View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Loaned to') }
      it { should have_content('Reported by') }
      it { should have_link('Options') }
      it { should have_link('Edit Loan Record') }
      it { should have_link('Delete Loan Record') }
      it { should have_link('View Instrument') }
      
      describe 'should see Instrument details' do
        it { should have_content('Instrument Serial Number') }
       end
      
      describe "when clicking the edit button" do
        before { click_link "Edit Loan Record" }
        let!(:page_heading) {"Edit Loan Record " + @loan.id.to_s + ' for Instrument '+@instrument.id.to_s}
        
        describe 'should have a page heading for editing the correct loan record' do
          it { should have_content(page_heading) }
        end
      end 
      
    end
    
    describe "for signed in users who don't own the current loan instrument" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit loan_path(@loan)
       end 
       
       let!(:page_heading) {"Instrument Loan Record"}
        
       describe 'should have a page heading for the correct loan' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
       end
       
       describe 'should see status details' do
          it { should have_content('Loaned to') }
       end       
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Options') }
         it { should_not have_link('Edit Loan Record') }
         it { should_not have_link('Delete Loan record') }
       end 
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button" do
        before do 
          visit loan_path(id:@loan.id)
        end 
        
        let!(:page_heading) {"Instrument Loan Record"}
        
        describe 'should have a page heading for the correct loan' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Options') }
          it { should_not have_link('Edit Loan Record') }
          it { should_not have_link('Delete Loan Record') }
        end 
      end
    end
    
  end
  
  
  describe "edit page" do
    
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save  
      @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner of the instrument" do
      
      before do 
        sign_in(user) 
        visit edit_loan_path(@loan)
      end 
      
      it { should have_content('Edit Loan Record ' + @loan.id.to_s + ' for Instrument '+ @instrument.id.to_s) }
      it { should have_title(full_title('Edit Loan Record')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid loaned to information" do
        
          before do
            fill_in 'loan_loaned_to', with: ''
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
      
      describe "with an end date before a start date" do
        
        before do
          fill_in 'loan_startdate', with: Date.new(2014, 8, 11)
          fill_in 'loan_enddate', with: Date.new(2014, 7, 11)
        end
        
        it "should not create a Loan" do
          expect { click_button "Update" }.not_to change(Status, :count)
        end
                
        describe "it should have a targeted error" do
          before do
            click_button "Update"
          end
      
          describe "should return an error" do
            it { should have_content('End Date cannot precede Start Date') }
          end   
        end
        
      end
  
      describe "with valid information" do
  
        before do
          fill_in 'loan_loaned_to'  , with: 'edited loaned to'
        end
        
        it "should update, not add a status" do
          expect { click_button "Update" }.not_to change(Status, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('Loan Record Updated') }
          it { should have_title(full_title('Loan Record View')) }
        end
      
      end
      
    end  
    
    describe "for signed-in users who are not an owner" do
      let(:non_owner) { FactoryGirl.create(:user) }
      before do 
        sign_in(non_owner)
        visit edit_loan_path(@loan)
      end 
      
      describe 'should have a page heading for the correct loan' do
        it { should_not have_content('Edit') }
        it { should have_title('Home') }
        it { should have_content('Welcome to HIE Instrument Tracker') }
      end
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_loan_path(@loan) }
        it { should have_title('Sign in') }
      end
    end
  end
  
  
  describe "loan destruction" do
    before do 
      @instrument = FactoryGirl.create(:instrument)
      @instrument.users << user
      @instrument.save 
      @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
    end 
    
    describe "for signed-in users who are an owner" do  
      before do 
        sign_in(user) 
        visit loan_path(@loan)
      end   
      
      it "should delete" do
        expect { click_link "Delete Loan Record" }.to change(Status, :count).by(-1)
      end
      
      describe "should return to view page" do
        before { click_link "Delete Loan Record" }
        it { should have_content('Loan Record Deleted') }
        it { should have_title(full_title('Instrument View')) }
      end
    end
  end
  

end
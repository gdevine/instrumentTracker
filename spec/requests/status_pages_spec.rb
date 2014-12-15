require 'spec_helper'

describe "Status pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }

  describe "Index page" do
    
    describe "for signed-in users" do
      
      before { sign_in user }
      before { visit statuses_path }
      
      it { should have_content('Instruments Status List') }
      it { should have_title(full_title('Status List')) }
      it { should_not have_title('| Home') }
      
      describe "with no status records in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Status Records found')
        end
      end
      
      describe "with status records in the system" do
        before do    
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << user
          @instrument.save
          @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
          @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
          visit statuses_path
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Status Record ID')
        end
                   
        it "should list each status record" do
          Status.paginate(page: 1).each do |status|
            expect(page).to have_selector('table tr td', text: status.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should not be able to see instrument status list" do
        before { visit statuses_path }
        it { should_not have_content('Instruments Status List') }
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
      @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
    end
    
    describe "for signed-in users who are an owner on a loan record" do
      
      before do 
        sign_in(user) 
        visit instrument_status_path(instrument_id:@instrument.id, id:@loan.id)
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
    
    describe "who don't own the current loan instrument" do
       let(:non_owner) { FactoryGirl.create(:user) }
       before do 
         sign_in(non_owner)
         visit instrument_status_path(instrument_id:@instrument.id, id:@loan.id)
       end 
       
       let!(:page_heading) {"Instrument Loan Record"}
        
       describe 'should have a page heading for the correct service' do
          it { should have_selector('h2', :text => page_heading) }
       end
       
       describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
       end
       
       describe "should not see the edit and delete buttons" do
         it { should_not have_link('Edit Loan Record') }
         it { should_not have_link('Delete Loan record') }
       end 
    end
    
    describe "for non signed-in users" do
      describe "should still see the page but have no option button" do
        before do 
          visit instrument_status_path(instrument_id:@instrument.id, id:@loan.id)
        end 
        
        let!(:page_heading) {"Instrument Loan Record"}
        
        describe 'should have a page heading for the correct service' do
          it { should have_selector('h2', :text => page_heading) }
        end
        
        describe 'should see instrument details' do
          it { should have_content('Instrument Serial Number') }
        end
       
        describe "should not see the edit and delete buttons" do
          it { should_not have_link('Edit Loan Record') }
          it { should_not have_link('Delete Loan Record') }
        end 
      end
    end
    
  end

end
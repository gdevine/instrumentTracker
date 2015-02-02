require 'spec_helper'

describe "Status pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "Index page for all statuses per instrument" do
    
    describe "for signed-in users" do
      
      before do
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << user
        @instrument.save  
        sign_in user
        visit instrument_statuses_path(@instrument)
      end
      
      it { should have_content('Status List for Instrument '+@instrument.id.to_s) }
      it { should have_title(full_title('Status List')) }
      it { should_not have_title('| Home') }
      
      describe "with no status records in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Records found')
          expect(page).not_to have_content('View?')
        end
      end
      
      describe "with status records in the system" do
        before do    
          @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
          visit instrument_statuses_path(@instrument)
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'ID')
          expect(page).to have_selector('table tr th', text: 'Instrument Serial Number')
          expect(page).to have_selector('table tr th', text: 'View?')
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
        before do 
          @instrument = FactoryGirl.create(:instrument)
          @instrument.users << user
          @instrument.save
          @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
          visit instrument_statuses_path(@instrument)
        end
        
        it { should_not have_content('Status List for Instrument '+@instrument.id.to_s) }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  # describe "edit page" do
#           
    # before do 
      # @instrument = FactoryGirl.create(:instrument)
      # @instrument.users << user
      # @instrument.save  
      # @loan = FactoryGirl.create(:loan, instrument_id:@instrument.id, reporter:user)
      # @lost = FactoryGirl.create(:lost, instrument_id:@instrument.id, reporter:user)
    # end
#      
#     
    # describe "for signed-in users who are an owner of the instrument" do
#       
      # before do 
        # sign_in(user) 
        # visit edit_instrument_status_path(instrument_id:@instrument.id, id:@loan.id)
      # end 
#       
      # it { should have_content('Edit Loan Record ' + @loan.id.to_s + ' for Instrument '+ @instrument.id.to_s) }
      # it { should have_title(full_title('Edit Loan Record')) }
      # it { should_not have_title('| Home') }
#       
      # describe "with invalid information on a loan record" do
#         
          # before do
            # fill_in 'status_loaned_to', with: ''
            # click_button "Update"
          # end
#           
          # describe "should return an error" do
            # it { should have_content('error') }
          # end
#   
      # end
#       
      # describe "with an end date before a start date" do
#         
        # before do
          # fill_in 'status_startdate', with: DateTime.new(2014, 8, 11)
          # fill_in 'status_enddate', with: DateTime.new(2014, 7, 11)
        # end
#         
        # it "should not update a Status" do
          # expect { click_button "Update" }.not_to change(Status, :count)
        # end
#                 
        # describe "it should have a targeted error" do
          # before do
            # click_button "Update"
          # end
#       
          # describe "should return an error" do
            # it { should have_content('End Date cannot precede Start Date') }
          # end   
        # end
#         
      # end
#   
      # describe "with valid information" do
#   
        # before do
          # fill_in 'status_laoned_to'  , with: 'edited loaned to info'
        # end
#         
        # it "should update, not add an status" do
          # expect { click_button "Update" }.not_to change(Status, :count).by(1)
        # end
#         
        # describe "should return to view page" do
          # before { click_button "Update" }
          # it { should have_content('Loan Record Updated') }
          # it { should have_title(full_title('Instrument Loan Record View')) }
        # end
#       
      # end
#       
    # end  
#     
    # describe "for signed-in users who are not an owner" do
      # let(:non_owner) { FactoryGirl.create(:user) }
      # before do 
        # sign_in(non_owner)
        # visit edit_instrument_status_path(instrument_id:@instrument.id, id:@loan.id)
      # end 
#       
      # describe 'should have a page heading for the correct service' do
        # it { should_not have_content('Edit') }
        # it { should have_title('Home') }
        # it { should have_content('Welcome to HIE Instrument Tracker') }
      # end
    # end
#     
    # describe "for non signed-in users" do
      # describe "should be redirected back to signin" do
        # before { visit edit_instrument_status_path(instrument_id:@instrument.id, id:@loan.id) }
        # it { should have_title('Sign in') }
      # end
    # end
  # end
  

end
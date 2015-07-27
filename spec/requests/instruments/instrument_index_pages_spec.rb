require 'spec_helper'


describe "instrument pages:" do

  subject { page }

  describe "Index page" do
    
    describe "for non signed-in users" do
      describe "should show the list of instruments" do
        before { visit instruments_path }
        
        it { should have_content('Instrument List') }
        it { should have_title(full_title('Instrument List')) }
        it { should_not have_title('| Home') }
      end
    end
    
    
    describe "for signed-in users" do
      
      @technician = FactoryGirl.create(:user)
      @custodian = FactoryGirl.create(:custodian)
      @admin = FactoryGirl.create(:admin)
      
      users = [@technician, @custodian, @admin]
      
      users.each do |user|
        describe "with no instruments in the system" do
          before do 
            sign_in user
            visit instruments_path
          end
      
          it { should have_content('Instrument List') }
          it { should have_title(full_title('Instrument List')) }
          it { should_not have_title('| Home') }
      
          it "should have an information message" do
            expect(page).to have_content('No Instruments found')
          end
        end
      
        describe "with instruments in the system" do
          before do
            @inst = FactoryGirl.create(:instrument)
            @inst.users << user
            sign_in user          
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
    
    end
    
  end
  
end
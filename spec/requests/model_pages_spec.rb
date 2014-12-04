require 'spec_helper'

describe "model pages:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }

  describe "Index page" do
    
    describe "for signed-in users" do
      
      before { sign_in user }
      before { visit models_path }
      
      it { should have_content('Models List') }
      it { should have_title(full_title('Models List')) }
      it { should_not have_title('| Home') }
      
      describe "with no models in the system" do
        it "should have an information message" do
          expect(page).to have_content('No Models found')
        end
      end
      
      describe "with models in the system" do
        before do
          @mod = FactoryGirl.create(:model)
          visit models_path
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Model ID')
        end
                   
        it "should list each model" do
          Model.paginate(page: 1).each do |mod|
            expect(page).to have_selector('table tr td', text: mod.id)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should be able to see model list" do
        before { visit models_path }
        it { should have_content('Models List') }
        it { should_not have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "Show page" do
      
    before do 
      @mod = FactoryGirl.create(:model)
    end
    
    describe "for signed-in users who are an owner" do
      
      before do 
        sign_in(user) 
        visit model_path(@mod)
      end
      
      let!(:page_heading) {"Model " + @mod.id.to_s}
      
      it { should have_selector('h2', :text => page_heading) }
      it { should have_title(full_title('Model View')) }
      it { should_not have_title('| Home') }  
      it { should have_content('Model Type') }
      it { should have_content('Manufacturer') }
      it { should_not have_link('Options') } 
      
      # describe "should show correct user/owner associations" do
        # let!(:new_user1) { FactoryGirl.create(:user) }
        # let!(:new_user2) { FactoryGirl.create(:user) }
#         
        # before do         
          # @instrument.users << new_user1
          # @instrument.users << new_user2
          # visit instrument_path(@instrument)
        # end
#         
        # it { should have_content('Contacts for this Instrument') }
        # it { should have_content(user.firstname) }  
        # it { should have_content(new_user1.firstname) }  
        # it { should have_content(new_user2.firstname) }  
#               
      # end
      
    end
    
    describe "for non signed-in users" do
      describe "should still see the page" do
        before do 
         visit model_path(@mod)
        end 
        
        let!(:page_heading) {"Model " + @mod.id.to_s}
        
        describe 'should have a page heading for the correct model' do
          it { should have_selector('h2', :text => page_heading) }
        end
       
        describe "should not see option buttons" do
          it { should_not have_link('Options') }
        end 
      end
    end
    
  end
#   
#   
  # describe "edit page" do
#     
    # before do 
      # @instrument = FactoryGirl.create(:instrument)
      # @instrument.users << user
    # end 
#     
    # describe "for signed-in users who are an owner" do
#       
      # let!(:mymod) { FactoryGirl.create(:model) } 
#       
      # before do 
        # sign_in(user) 
        # visit edit_instrument_path(@instrument)
      # end 
#       
      # it { should have_content('Edit Instrument ' + @instrument.id.to_s) }
      # it { should have_title(full_title('Edit Instrument')) }
      # it { should_not have_title('| Home') }
#       
      # describe "with invalid serial number information" do
#         
          # before do
            # fill_in 'instrument_serialNumber', with: ''
            # click_button "Update"
          # end
#           
          # describe "should return an error" do
            # it { should have_content('error') }
          # end
#   
      # end
#       
      # describe "with invalid model choice" do
#         
          # before do
            # find('#models').find(:xpath, 'option[1]').select_option
            # click_button "Update"
          # end
#           
          # describe "should return an error" do
            # it { should have_content("Model can't be blank") }
          # end
#   
      # end
#   
      # describe "with valid information" do
#   
        # before do
          # fill_in 'instrument_serialNumber'  , with: 'dummyserial'
          # fill_in 'instrument_price'   , with: 678.00
        # end
#         
        # it "should update, not add an instrument" do
          # expect { click_button "Update" }.not_to change(Instrument, :count).by(1)
        # end
#         
        # describe "should return to view page" do
          # before { click_button "Update" }
          # it { should have_content('Instrument updated') }
          # it { should have_title(full_title('Instrument View')) }
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
        # visit edit_instrument_path(@instrument)
      # end 
#       
      # describe 'should have a page heading for the correct instrument' do
        # it { should_not have_content('Edit') }
        # it { should have_title('Home') }
        # it { should have_content('Welcome to HIE Instrument Tracker') }
      # end
    # end
#     
    # describe "for non signed-in users" do
      # describe "should be redirected back to signin" do
        # before { visit edit_instrument_path(@instrument) }
        # it { should have_title('Sign in') }
      # end
    # end
  # end
#   
#   
  # describe "instrument destruction" do
    # before do 
      # @instrument = FactoryGirl.create(:instrument)
      # @instrument.users << user
    # end 
#     
    # describe "for signed-in users who are an owner" do  
      # before do 
        # sign_in(user) 
        # visit instrument_path(@instrument)
      # end   
      # it "should delete" do
        # expect { click_link "Delete Instrument" }.to change(Instrument, :count).by(-1)
      # end
    # end
  # end

end
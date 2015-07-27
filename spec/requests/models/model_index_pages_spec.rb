require 'spec_helper'

describe "model pages:" do

  subject { page }
  
  describe "Index page" do
    
    # First set up some models  

    describe "for non signed-in users" do
      describe "with no models in the system" do
        before do 
          visit models_path
        end
    
        it { should have_content('Models List') }
        it { should have_title(full_title('Models List')) }
        it { should_not have_title('| Home') }
    
        it "should have an information message" do
          expect(page).to have_content('No Models found')
        end
      end
      
      describe "with models in the system" do
        before do 
          @mod1 = FactoryGirl.create(:model)
          @mod2 = FactoryGirl.create(:model)
          visit models_path
        end
        
        it { should have_content('Models List') }
        it { should have_title(full_title('Models List')) }
        it { should_not have_title('| Home') }
        it { should have_selector('table tr th', text: 'Model ID') }
        it { should have_content('Model ID') }
        it "should list each model" do
          Model.paginate(page: 1).each do |mod|
            expect(page).to have_selector('table tr td', text: mod.id)
          end
        end
      end
    end    
    
    
    describe "for signed-in users" do
      
      users = [FactoryGirl.create(:user), FactoryGirl.create(:custodian) , FactoryGirl.create(:admin)]
      users.each do |user|
        describe "across all roles" do
          before do
            @mod1 = FactoryGirl.create(:model)
            @mod2 = FactoryGirl.create(:model)
            sign_in user 
            visit models_path
          end 
          
          it { should have_content('Models List') }
          it { should have_title(full_title('Models List')) }
          it { should_not have_title('| Home') }
          it { should have_selector('table tr th', text: 'Model ID') }
          it "should list each model" do
            Model.paginate(page: 1).each do |mod|
              expect(page).to have_selector('table tr td', text: mod.id)
            end
          end
          
        end
      end
      
    end
    
        
  end

end
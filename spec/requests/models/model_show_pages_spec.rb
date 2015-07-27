require 'spec_helper'

describe "model pages:" do

  subject { page }
  
  describe "Show page" do
    
    describe "for signed-in users" do
      
  
      @technician = FactoryGirl.create(:user)
      @custodian = FactoryGirl.create(:custodian)
      @admin = FactoryGirl.create(:admin)
      users = [@technician, @custodian, @admin]
      
      users.each do |user|
        
        describe "across all roles" do
          
          before do 
            @mod =  FactoryGirl.create(:model)
            sign_in(user) 
            visit model_path(@mod)
          end
          
          let!(:page_heading) {"Model " + @mod.id.to_s}
          
          it { should have_selector('h2', :text => page_heading) }
          it { should have_title(full_title('Model View')) }
          it { should_not have_title('| Home') }  
          it { should have_content('Model Type') }
          it { should have_content('Manufacturer') }
  
        end
      end            
    end
    
    describe "for non signed-in users" do
      describe "should still see the page" do
        
        before do 
          @mod =  FactoryGirl.create(:model)
          visit model_path(@mod)
        end
        
        let!(:page_heading) {"Model " + @mod.id.to_s}
        it { should have_selector('h2', :text => page_heading) }
        it { should have_content('Model Type') }
        it { should have_content('Manufacturer') }
       
      end
    end
    
  end

end
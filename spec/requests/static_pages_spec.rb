require 'spec_helper'

describe "Static pages:" do
  
  subject { page }
  
  describe "Home page" do 
    
    describe "when not logged in" do
      before { visit root_path }
      it { should have_title(full_title('Home')) }
    end
    
    describe "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit root_path
      end
      it { should have_content('Sign out, ' + user.firstname.capitalize) }
      it { should_not have_content('Sign in') }
      it { should have_title(full_title('Home')) }
    end
    
  end
  
  
  describe "Dashboard page" do 
    
    describe "when not logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        @instrument = FactoryGirl.create(:instrument)
        @instrument.users << user
        @instrument.save
        @facedeployment = FactoryGirl.create(:facedeployment, instrument_id:@instrument.id, reporter:user)
        (1..5).each do 
          newdeploy = @facedeployment.dup
          newdeploy.save
        end
        visit dashboard_path 
      end
      
      it { should have_title(full_title('Dashboard')) }
      it { should have_content('Instruments currently deployed at FACE') }
      it { should have_content('1') }
      
    end
    
    describe "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit root_path
      end
      it { should have_content('Sign out') }
      it { should_not have_content('Sign in') }
      it { should have_title(full_title('Home')) }
    end
    
  end
  
  
  describe "Help page" do
    
    describe "when not logged in" do
      before { visit help_path }
      it { should have_title('Help') }
      it { should have_content('Sign in') }
    end
    
    describe "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit help_path
      end

      it { should have_content('Sign out') }
      it { should_not have_content('Sign in') }
      it { should have_title(full_title('Help')) }
    end
  
  end
  
  describe "About page" do
    before { visit about_path }

    it { should have_title(full_title('About')) }
    it { should have_content('about Base App 1') }
  end
  
  describe "Help page" do
    before { visit help_path }

    it { should have_title(full_title('Help')) }
    it { should have_content('Help') }
  end
  
  
  describe "Contact page" do
    before { visit contact_path }

    it { should have_title(full_title('Contact')) }
    it { should have_content('Contact') }
  end
  
end
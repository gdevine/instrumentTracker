require 'spec_helper'

describe "User pages" do

  subject { page }
  
  describe "register page" do

    before { visit new_user_registration_path }
    
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "First Name",    with: "Example"
        fill_in "Surname",      with: "Bla"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobarbar"
        fill_in "Confirm Password", with: "foobarbar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }
               
        it { should have_link('Sign in') }  # As the account has not been approved yet therefore unable to log in
        it { should have_content('Instrument Tracker') }
        it { should have_selector('div.alert.alert-notice', text: 'You have signed up successfully but your account has not been approved by your administrator yet') }
      end      
    end        
               
  end
  
  describe "signin page" do

    before { visit new_user_session_path }
    
    it { should have_content('Sign in') }
    it { should have_title(full_title('Sign in')) }

    let(:submit) { "Sign in" }

    describe "should not sign in with invalid information" do
      before { click_button submit }
      it { should have_content('Invalid email or password') }
      it { should have_content('Sign in') }
      it { should_not have_content('Sign out') }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) } 
      let(:submit) { "Sign in" }
      before do
        fill_in "Email",        with: user.email
        fill_in "Password",     with: user.password
        click_button submit
      end   
      it { should have_content('Sign out') }
      it { should_not have_content('Sign in') }
    end        
               
  end
  
end

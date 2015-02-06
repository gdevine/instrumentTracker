require 'spec_helper'

describe "Menu Panel:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  # Checking that the menu bar appears when it's supposed to
  describe "Home page" do
    describe "for signed-in users" do
      before do 
        sign_in(user) 
        visit root_path
      end
        
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector('nav#minibar')
      end
    end
    
    describe "for non signed-in users" do
      before { visit root_path }
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector('nav#minibar')
      end
    end
  end
  
  # The menu bar should appear on the standard static pages: contact page, about page etc if logged in
  describe "Help page" do
    describe "for signed-in users" do
      before do 
        sign_in(user)
        visit help_path
      end
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector('nav#minibar')
      end
    end
    
    describe "for non signed-in users" do
      before { visit help_path }
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector('nav#minibar')
      end
    end
  end
  
  describe "About page" do
    describe "for signed-in users" do
      before do 
        sign_in(user)
        visit about_path
      end
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector("nav#minibar")
      end
    end
    
    describe "for non signed-in users" do
      before { visit about_path }
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector("nav#minibar")
      end
    end
  end
  
  describe "Contact page" do
    describe "for signed-in users" do
      before do 
        sign_in(user)
        visit contact_path
      end
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector('nav#minibar')
      end
    end
    
    describe "for non signed-in users" do
      before { visit contact_path }
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector('nav#minibar')
      end
    end
  end
  
  # The menu bar should appear on sign-in or register error pages
  describe "Sign in error page" do
    before do 
      visit new_user_session_path
      click_button "Sign in"
    end
    it 'should have a nav#minibar bar' do
      expect(page).to have_selector('nav#minibar')
    end
  end
  
  describe "Register error page" do
    before do
      visit new_user_registration_path
      click_button "Create my account"
    end

    it 'should have a nav#minibar bar' do
      expect(page).to have_selector('nav#minibar')
    end
  end
  
  # Dashboard Link
  describe "Visitng the home page" do
    describe "when signed in" do
      before do
        sign_in(user)
        visit root_path
      end
      it "should show a link for Dashboard" do
        expect(page).to have_link('dashboard_link')
      end
      
      describe "and clicking the Dashboard link" do
        before do
          click_link('dashboard_link')
        end
    
        it "should open up the Dashboard page" do
          expect(page).to have_title('Dashboard')
          expect(page).to have_content('Instrument Tracker Dashboard')
        end
      end
      
    end
    
    describe "when not signed in" do
      before do 
        visit root_path
      end
      it "should show a link for Dashboard" do
        expect(page).to have_link('dashboard_link')
      end
    end
    

  end 
   
   
  # Instrument dropdown links
  
  describe "opening the Instruments dropdown" do

    describe "when signed in" do
      before do 
        sign_in(user) 
        visit root_path
      end
      
      it "should show a link for 'Create New' Instrument" do
        expect(page).to have_link('instruments_new')
      end
      it "should show a link for 'View All' Instrument" do
        expect(page).to have_link('instruments_index')
      end
      
      describe "and clicking the View All link" do
        before do
          click_link('instruments_index')
        end
    
        it "should open up the View All page" do
          expect(page).to have_title('Instrument List')
        end
      end
      
      describe "and clicking the View Lost Instruments link" do
        before do
          click_link('losts_index')
        end
    
        it "should open up the View current losts page" do
          expect(page).to have_title('Lost List')
        end
      end
      
      describe "and clicking the View In Storage link" do
        before do
          click_link('storages_index')
        end
    
        it "should open up the View current storages page" do
          expect(page).to have_title('In Storage List')
        end
      end
      
      describe "and clicking the View Face Deployment link" do
        before do
          click_link('facedeployments_index')
        end
    
        it "should open up the View current face deployments page" do
          expect(page).to have_title('FACE Deployment List')
        end
      end
      
      describe "and clicking the View Retired link" do
        before do
          click_link('retirements_index')
        end
    
        it "should open up the View current retirements page" do
          expect(page).to have_title('Retired List')
        end
      end
      
      describe "and clicking the Create New link" do
        before do
          FactoryGirl.create(:model)
          click_link('instruments_new')
        end
    
        it "should open up the Create Instrument page" do
          expect(page).to have_title('New Instrument')
        end
      end
    
    end
    
    describe "when not signed in" do
      before do
        visit root_path
      end
      
      it "should not show a link for 'Create New' Instrument" do
        expect(page).not_to have_link('instruments_new')
      end
      it "should show a link for 'View All' Instrument" do
        expect(page).to have_link('instruments_index')
      end
    end
    
  end
  
  
# Resources menu
  
  describe "opening the resources dropdown" do
    before { sign_in(user) }
    before { visit root_path }
    
    describe "and clicking the models link" do
      before do
        click_link('Models')
      end
  
      it "should open up the models index page" do
        expect(page).to have_title('Models List')
      end
    end
  end
  

end

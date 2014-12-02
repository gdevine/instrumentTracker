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
      
      describe "and clicking the Create New link" do
        before do
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
  
end
  
#   
  # describe "opening the facility dropdown" do
    # before { sign_in(user) }
    # before { visit root_path }
#     
    # describe "and clicking the View link" do
      # before do
        # click_link('Facilities')
      # end
#   
      # it "should open up the facility index page" do
        # expect(page).to have_title('Facility List')
      # end
    # end
  # end
#   
#   
  # describe "opening the container dropdown" do
    # before { sign_in(user) }
    # before { visit root_path }
#     
    # describe "and clicking the Create New link" do
      # before do
        # click_link('containers_new')
      # end
#   
      # it "should open up the new container page" do
        # expect(page).to have_title('New Container')
      # end
    # end
#     
    # describe "and clicking the View All link" do
      # before do
        # click_link('containers_index')
      # end
#   
      # it "should open up the container index page" do
        # expect(page).to have_title('Containers List')
      # end
    # end

  
  
# Resources menu
  
  # describe "opening the facility dropdown" do
    # before { sign_in(user) }
    # before { visit root_path }
#     
    # describe "and clicking the View link" do
      # before do
        # click_link('Facilities')
      # end
#   
      # it "should open up the facility index page" do
        # expect(page).to have_title('Facility List')
      # end
    # end
  # end
  
  # describe "opening the project dropdown" do
    # before { sign_in(user) }
    # before { visit root_path }
#     
    # describe "and clicking the View link" do
      # before do
        # click_link('Projects')
      # end
#   
      # it "should open up the project index page" do
        # expect(page).to have_title('Project List')
      # end
    # end
  # end
  
  # describe "opening the storage locations dropdown" do
    # before { sign_in(user) }
    # before { visit root_path }
#     
    # describe "and clicking the View link" do
      # before do
        # click_link('Storage Locations')
      # end
#   
      # it "should open up the storage locations index page" do
        # expect(page).to have_title('Storage Location List')
      # end
    # end
  # end
  
  # describe "opening the analysis dropdown" do
    # before { sign_in(user) }
    # before { visit root_path }
#     
    # describe "and clicking the View link" do
      # before do
        # click_link('Analysis Types')
      # end
#   
      # it "should open up the analysis type index page" do
        # expect(page).to have_title('Analysis Type List')
      # end
    # end
  # end
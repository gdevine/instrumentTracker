require 'spec_helper'

describe User do

  before { @user = User.new(firstname: "Example", surname: "Blabla", email: "user@example.com",
                            password: "foobarbar", password_confirmation: "foobarbar") }
  
  subject { @user }

  it { should respond_to(:firstname) }
  it { should respond_to(:surname) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:approved) }

  it { should be_valid }
  it { should_not be_approved }
  
  describe "with approved attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:approved)
    end

    it { should be_approved }
  end
  
  
  # Presence checks
  describe "when firstname is not present" do
    before { @user.firstname = " " }
    it { should_not be_valid }
  end
  
  describe "when surname is not present" do
    before { @user.surname = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before do
      @user = User.new(firstname: "Example", surname: "blabla", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end
  
  
  #Length checks
  describe "when firstname is too long" do
    before { @user.firstname = "a" * 51 }
    it { should_not be_valid }
  end
 
 describe "when surname is too long" do
    before { @user.surname = "a" * 51 }
    it { should_not be_valid }
  end
  
  
  # email checks
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end 
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  #Password checks
  describe "when password is not present" do
    before do
      @user = User.new(firstname: "Example", surname: "bla" ,email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  
  describe "instrument associations" do
    
    let!(:instrument_middle) {FactoryGirl.create(:instrument, created_at: 1.day.ago)}
    let!(:instrument_newest) {FactoryGirl.create(:instrument, created_at: 1.hour.ago)}
    let!(:instrument_oldest) {FactoryGirl.create(:instrument, created_at: 1.month.ago)}
    
    before do 
      @user.save
      @user.instruments << instrument_middle
      @user.instruments << instrument_oldest
      @user.instruments << instrument_newest
    end
       
    it "should have associated instruments in order of creation, newest first" do
      expect(@user.instruments).to eq [instrument_newest, instrument_middle, instrument_oldest]
    end
    
  end
  
end

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com", 
      :password => "foobar",
      :password_confirmation => "foobar"
      }
  end
  it "should crease a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => "")) #page 209 merge method
    no_name_user.should_not be_valid
  end
  
  it "should require an email adddress" do
    no_email_user = User.new(@attr.merge(:email => "")) 
    no_email_user.should_not be_valid   
  end
  
  it "should should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid 
  end
  
  it "should should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should_not be_valid
    end
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase #take user created at top and make email upper case
    User.create!(@attr.merge(:email => upcased_email)) #create a new user with the same upper case email
    user_with_duplicate_email = User.new(@attr) #add that email to a new user
    user_with_duplicate_email.should_not be_valid #it shouldn't be valid
  end
    
  describe "password validations" do
    it "should require a password " do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = User.new(@attr.merge(:password => short, :password_confirmation => short))
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = User.new(@attr.merge(:password => long, :password_confirmation => long))
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authentication method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
      
    end

  end
end
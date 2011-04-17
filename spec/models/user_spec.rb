require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
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
  
end
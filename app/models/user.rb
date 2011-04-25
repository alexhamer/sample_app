# == Schema Information
# Schema version: 20110419210346
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :password #ALEX reates getting and setter methods to manipulate passwords
  attr_accessible :name, :email, :password, :password_confirmation
  
  #validates(:name, :presence => true)
  
  #name
  validates_presence_of :name, :on => :create, :message => "can't be blank mother fucker"
  validates_length_of :name, :within => 3..50, :on => :create, :message => "must be withint 3 to 50 characters"

  #email 
  validates_presence_of :email, :on => :create, :message => "can't be blank asswipe"
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, :with => email_regex, :on => :create, :message => "is invalid"
  validates_uniqueness_of :email, :on => :create, :message => "must be unique", :case_sensitive => false
  
  #password
  validates_presence_of :password, :on => :create, :message => "can't be blank"
  validates_confirmation_of :password, :on => :create, :message => "should match confirmation"
  validates_length_of :password, :within => 6..40, :on => :create, :message => "must be within 6 to 40 characters"

  before_save :encrypt_password
  
  #Return true if the user's password matched the submitted password
  def has_password?(submitted_password)
    #compare encrypted_password with the encrypted version of submitted_password
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password) #refers to class (class level method) itself could do class << self 
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) #could also use (self.password)
      #above if you use only encryypted_password not self.encrypted_password it would create a local variable
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    

end

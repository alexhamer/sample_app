# == Schema Information
# Schema version: 20110411152244
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :name, :email
  
  #validates(:name, :presence => true)
  
  #name
  validates_presence_of :name, :on => :create, :message => "can't be blank mother fucker"
  validates_length_of :name, :within => 3..50, :on => :create, :message => "must be present"

  #email
  validates_presence_of :email, :on => :create, :message => "can't be blank asswipe"
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, :with => email_regex, :on => :create, :message => "is invalid"
  validates_uniqueness_of :email, :on => :create, :message => "must be unique", :case_sensitive => false
end

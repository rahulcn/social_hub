require 'digest/sha2'
class User < ActiveRecord::Base
 
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_one :info
 
  has_many :microposts, :dependent => :destroy
  has_many :messages,   :dependent => :destroy

  
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy

  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  email_regex = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
                   
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                   
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password
  
  def match_password?(submitted_password)
    encrypted_password == password_with_salt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.match_password?(submitted_password)) ? user : nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt)? user :nil
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = password_with_salt(password)
    end

    def password_with_salt(password="", salt="")
      secure_hash("use #{password} with #{salt} to make the salted password")
    end
    
    def make_salt(username="")
      secure_hash("use #{username} with #{Time.now.utc} to make the salt")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
# == Schema Information
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
#  admin              :boolean         default(FALSE)
#


class User < ActiveRecord::Base
  has_secure_password
  has_many :cars
  validates :username, uniqueness: true
  validates :email, uniqueness: true
  # validates :username, :length => true
end
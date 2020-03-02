class User < ActiveRecord::Base
  has_secure_password
  has_many :cars
  validates :username, presence: true
  validates :password, presence: true
  validates :email, presence: true
  validates :username, uniqueness: true
  validates :email, uniqueness: true, format:  {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "not valid"}
  # validates :username, :length => true
end
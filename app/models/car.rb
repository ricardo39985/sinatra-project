class Car < ActiveRecord::Base
  belongs_to :user
  validates :year, format: { with: /(\d{4})/, message: "must be numbers" }
  validates :year, length: { is: 4 }, allow_blank: true
  validates :make, format:  {with: /[a-zA-Z]/, message: "must be only letters"}, allow_blank: true
  

end
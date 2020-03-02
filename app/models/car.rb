class Car < ActiveRecord::Base
  belongs_to :user
  validates :year, format: { with: /(\d{4})/, message: "must be numbers" }
  validates :year, length: { is: 4 }, allow_blank: true
  validates :make, format:  {with: /[a-zA-Z]/, message: "must be only letters"}, allow_blank: true
  validates_numericality_of :year, greater_than: 1885
  validates_numericality_of :year, less_than: 2024

  

end
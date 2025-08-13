class Company < ApplicationRecord
  has_many :users
  has_many :items
  has_many :purchases
  has_many :portions
  has_many :products
end

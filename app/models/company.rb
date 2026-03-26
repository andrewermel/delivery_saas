class Company < ApplicationRecord
  has_many :users
  has_many :items, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :inventories, dependent: :destroy
  has_many :portions
  has_many :products

  validates :name, presence: true
  validates :cnpj_id, presence: true, uniqueness: true
end

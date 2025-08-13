class Item < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
  validates :weight, presence: true
end

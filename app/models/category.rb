class Category < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy
  validates :name, presence: true, length: {maximum: 255}, allow_nil: true

  scope :search, ->keyword {where "name LIKE ?", "%#{keyword}%"}
end

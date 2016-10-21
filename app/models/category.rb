class Category < ApplicationRecord
  has_many :lession, dependent: :destroy
  has_many :word, dependent: :destroy
  validates :name, presence: true,
    length: {maximum: 255},
    allow_nil: true
end

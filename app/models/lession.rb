class Lession < ApplicationRecord
  belongs_to :category
  has_many :word
  validates :user_id, presence: true
end

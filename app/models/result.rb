class Result < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  belongs_to :word
  has_many :choices
end

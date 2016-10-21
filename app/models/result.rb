class Result < ApplicationRecord
  belongs_to :lession
  belongs_to :user
  belongs_to :word
  has_many :choices
end

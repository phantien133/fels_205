class Answer < ApplicationRecord
  belongs_to :word
  validates :content,
    presence: true,
    length: {maximum: 1000},
    allow_nil: true
end

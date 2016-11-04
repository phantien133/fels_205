class Answer < ApplicationRecord
  belongs_to :word
  validates :content,
    presence: true,
    length: {maximum: Settings.max_length_of_content.to_i},
    allow_nil: true
end

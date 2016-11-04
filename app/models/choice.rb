class Choice < ApplicationRecord
  belongs_to :result
  belongs_to :word
  belongs_to :answer, optional: true
  scope :scores, -> {joins(:answer).where("answers.correct = ?", true).count}
end

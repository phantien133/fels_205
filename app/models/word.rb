class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy

  scope :search_by_content, ->keyword {where "content LIKE ?", "%#{keyword}%"}
  scope :of_category, ->category_id {where category_id: category_id}
  scope :random_words, -> {order "random()"}
  scope :correct_answers, -> {joins(:answers).where scorrect: true}
end

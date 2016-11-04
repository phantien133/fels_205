class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy

  validates :content,
    presence: true,
    length: {maximum: 1000},
    allow_nil: true

  accepts_nested_attributes_for :answers,
  reject_if: proc {|attributes| attributes[:content].blank?},
  allow_destroy: true

  scope :search_by_content, ->keyword {where "content LIKE ?", "%#{keyword}%"}
  scope :of_category, ->category_id {where category_id: category_id}
  scope :random_words, -> {order "random()"}

  before_update :check_validates_answers

  def correct_answer
    self.answers.find_by correct: true
  end

  private
  def check_validates_answers
    if self.answers.size < 2 || self.correct_answer != 1
      self.errors.add :correct, I18n.t(:word_should_have)
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end
end

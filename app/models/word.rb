class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :choices
  has_many :results, through: :choices

  validates :content,
    presence: true,
    length: {maximum: Settings.max_length_of_content.to_i},
    allow_nil: true

  accepts_nested_attributes_for :answers,
  reject_if: proc {|attributes| attributes[:content].blank?},
  allow_destroy: true

  scope :search_by_content, ->keyword {where "content LIKE ?", "%#{keyword}%"}
  scope :of_category, ->category_id do
    where category_id: category_id if category_id.present?
  end
  scope :delete_words_of_category, ->category_id do
    where(category_id: category_id).update_all(deleted: true)
  end
  scope :random_words, -> {order "random()"}
  scope :corrects, ->{includes(:answers).where(correct: true).count}
  scope :learned, ->user_id do
    joins(:choices).joins(:results).where "results.user_id = ?", user_id
  end
  scope :not_learned, ->user_id do
    where 'id NOT IN (SELECT word_id FROM choices WHERE result_id IN
      (SELECT id FROM results WHERE user_id = ?))', user_id
  end

  after_update :check_validates_answers

  def correct_answer
    answers.find_by correct: true
  end

  def category
    Category.unscoped { super }
  end

  def corrects
    answers.where(correct: true).count
  end

  private
  def check_validates_answers
    if answers.size < 2 || corrects != 1
      errors.add :correct, I18n.t(:word_should_have)
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end
end

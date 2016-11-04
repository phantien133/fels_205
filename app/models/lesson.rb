class Lesson < ApplicationRecord
  belongs_to :category
  has_many :results

  validates :user_id, presence: true
  validates :number_of_words, presence: true, length: {minimum: 1}
  validates :time, presence: true, length: {minimum: 1}
  validates_numericality_of :number_of_words,
    greater_than_or_equal_to: Settings.min_words.to_i
  validates_numericality_of :time, greater_than_or_equal_to: Settings.time.to_i

  before_save :check_access_category

  default_scope {where deleted: false}
  scope :of_category, ->category_id do
    where(category_id: category_id) if category_id.present?
  end
  scope :search, ->keyword {where "name LIKE ?", "%#{keyword}%"}
  scope :delete_lessons_of_category, ->category_id do
    where(category_id: category_id).update_all(deleted: true)
  end
  scope :not_learned, ->user_id do
    where "id NOT IN (SELECT lesson_id FROM results WHERE user_id = ?)", user_id
  end
  scope :learned, ->user_id {joins(:results).where "results.user_id = ?", user_id}

  def check_number_of_word?
    category.words.size - number_of_words > -number_of_words / Settings.words
  end

  def is_tested
    Result.where(lesson_id: self.id).size > 0
  end

  def delete
    self.update_attributes deleted: true
  end

  private
    def check_access_category
      unless time > Settings.min_time &&
        number_of_words > Settings.min_words
        errors.add :min_value, I18n.t(:time_and_number_validates)
        raise ActiveRecord::RecordInvalid.new(self)
      end
      if number_of_words > Word.of_category(category_id).count
        errors.add :number_of_words, I18n.t(:max_of_words, max: Word.of_category(category_id).size)
        raise ActiveRecord::RecordInvalid.new(self)
      end
    end
end

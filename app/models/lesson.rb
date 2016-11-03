class Lesson < ApplicationRecord
  belongs_to :category
  has_many :results

  validates :user_id, presence: true
  validates :number_of_words, presence: true, length: {minimum: 1}, allow_nil: true
  validates :time, presence: true, length: {minimum: 1}, allow_nil: true
  validate :check_access_category

  scope :of_category, ->category_id {where(category_id: category_id)}
  scope :search, ->keyword {where "name LIKE ?", "%#{keyword}%"}

  scope :not_learned, ->user_id do
    where "id NOT IN (SELECT lesson_id FROM results WHERE user_id = ?))", user_id
  end
  scope :learned, ->user_id {joins(:results).where "results.user_id = ?", user_id}

  def check_number_of_word?
    self.category.words.size - number_of_words > -number_of_words / Settings.words
  end

  private
    def check_access_category
      unless self.time > Settings.min_time &&
        self.number_of_words > Settings.min_words
        errors.add :min_value, t(:time_and_number_validates)
      end
      if self.number_of_words > Word.of_category(self.category_id).count
        errors.add :max_number_of_words, t(:max_of_words, max: max_number_of_words)
      end
    end
end

class Category < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy
  validates :name, presence: true, length: {maximum: 255}, allow_nil: true

  default_scope {where deleted: false}
  scope :search, ->keyword {where "name LIKE ?", "%#{keyword}%"}

  def is_tested
    Result.joins(:lesson).where('lessons.category_id= ?', self.id).size > 0
  end

  def delete
    Lesson.delete_lessons_of_category self.id
    Word.delete_words_of_category self.id
    self.update_attributes deleted: true
  end
end

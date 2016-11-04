class Result < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  has_many :choices, dependent: :destroy
  has_many :words, through: :choices

  accepts_nested_attributes_for :choices,
    reject_if: proc {|attributes| attributes[:answer_id].blank?},
    allow_destroy: true

  after_create :create_test
  after_update :create_finished_lesson_activity

  private
    def create_test
      words_test = self.lesson.category.words.random_words
        .limit self.lesson.number_of_words
      words_test.each do |word|
        choice = self.choices.build word_id: word.id
        unless choice.save
          self.errors.add :words_test, I18n.t(:word_not_enough)
        end
      end
      create_start_lesson_activity
    end

    def create_finished_lesson_activity
      create_activity_of_lesson Activity.activity_types[:updated] if finished
    end

    def create_start_lesson_activity
      create_activity_of_lesson Activity.activity_types[:created]
    end

    def create_activity_of_lesson action_type
      Activity.create user_id: user_id, target_id: id, target_type: Lesson.name,
      action_type: action_type
    end
end

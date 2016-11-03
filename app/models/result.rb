class Result < ApplicationRecord
  belongs_to :lession
  belongs_to :user
  has_many :choices, dependent: :destroy
  has_many :words, through: :choices

  accepts_nested_attributes_for :choices,
    reject_if: proc {|attributes| attributes[:answer_id].blank?},
    allow_destroy: true

  after_save :create_test

  private
    def create_test
      words_test = self.lession.category.words.random_words
        .limit self.lession.number_of_words
      words_test.each do |word|
        choice = self.choices.build word_id: word.id
        unless choice.save
          self.errors[:base] << t :word_not_enough
        end
      end
    end
end

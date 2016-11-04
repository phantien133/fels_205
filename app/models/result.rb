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
      words_test = lession.category.words.random_words
        .limit lession.number_of_words
      words_test.each do |word|
        choice = choices.build word_id: word.id
        unless choice.save
          errors.add :words_test, I18n.t(:word_not_enough)
        end
      end
    end
end

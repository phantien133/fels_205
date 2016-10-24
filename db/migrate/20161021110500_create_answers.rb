class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.references :word, foreign_key: true
      t.text :content
      t.boolean :correct, default: false

      t.timestamps
    end
  end
end

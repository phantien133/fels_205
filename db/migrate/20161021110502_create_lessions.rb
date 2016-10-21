class CreateLessions < ActiveRecord::Migration[5.0]
  def change
    create_table :lessions do |t|
      t.references :user, foreign_key: true
      t.integer :category, foreign_key: true
      t.string :name
      t.integer :number_of_words
      t.integer :time

      t.timestamps
    end
  end
end

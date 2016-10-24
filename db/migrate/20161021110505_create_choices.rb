class CreateChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :choices do |t|
      t.references :result, foreign_key: true
      t.references :anser, foreign_key: true

      t.timestamps
    end
  end
end

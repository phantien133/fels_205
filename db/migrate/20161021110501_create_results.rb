class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :user, foreign_key: true
      t.references :lession, foreign_key: true

      t.timestamps
    end
  end
end

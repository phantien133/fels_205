class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :user, foreign_key: true
      t.references :lesson, foreign_key: true
      t.boolean :finished, default: false

      t.timestamps
    end
  end
end

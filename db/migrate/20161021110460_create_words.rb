class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.references :category, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end

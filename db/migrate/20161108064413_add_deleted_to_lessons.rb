class AddDeletedToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :deleted, :boolean, default: false
  end
end

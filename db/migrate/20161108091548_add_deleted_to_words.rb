class AddDeletedToWords < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :deleted, :boolean, default: false
  end
end

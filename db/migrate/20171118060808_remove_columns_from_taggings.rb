class RemoveColumnsFromTaggings < ActiveRecord::Migration[5.1]
  def change
    remove_column :taggings, :score, :decimal
  end
end

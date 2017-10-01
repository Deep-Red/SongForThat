class AddCategoryToTagging < ActiveRecord::Migration[5.1]
  def change
    add_column :taggings, :category, :string
    add_index :taggings, :category
  end
end

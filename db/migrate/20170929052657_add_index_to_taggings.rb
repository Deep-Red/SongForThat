class AddIndexToTaggings < ActiveRecord::Migration[5.1]
  def change
    add_index :taggings, [:song_id, :tag_id, :category], unique: true
  end
end

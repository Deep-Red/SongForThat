class AddIndexesToTaggings < ActiveRecord::Migration[5.1]
  def change
    add_index :taggings, [:song_id, :tag_id], unique: true
  end
end

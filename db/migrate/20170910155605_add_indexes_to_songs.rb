class AddIndexesToSongs < ActiveRecord::Migration[5.1]
  def change
    add_index :songs, :title
    add_index :songs, :artist
    add_index :songs, [:title, :artist], unique: true
  end
end

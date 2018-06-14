class IndexSongsUsingGist < ActiveRecord::Migration[5.1]
  def change
    remove_index :songs, [:title, :artist]
    add_index :songs, [:title, :artist], using: :gist
  end
end

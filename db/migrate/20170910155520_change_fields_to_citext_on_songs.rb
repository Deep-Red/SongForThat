class ChangeFieldsToCitextOnSongs < ActiveRecord::Migration[5.1]
  def up
    change_column :songs, :title, :citext
    change_column :songs, :artist, :citext
  end
  def down
    change_column :songs, :title, :string
    change_column :songs, :artist, :string
  end
end

class AddMbReferencesToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :mb_recording, :integer
    add_column :songs, :mb_artist_credit, :integer
    add_column :songs, :mb_work, :integer
  end
end

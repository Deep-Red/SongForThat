class AddYearToSong < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :year, :integer
    add_index :songs, :year
  end
end

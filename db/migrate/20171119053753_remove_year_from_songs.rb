class RemoveYearFromSongs < ActiveRecord::Migration[5.1]
  def change
    remove_column :songs, :year, :integer
  end
end

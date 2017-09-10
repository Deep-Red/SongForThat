class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.references :added_by, references: :user

      t.timestamps
    end
  end
end

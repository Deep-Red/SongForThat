class ChangeNameToCitextOnTags < ActiveRecord::Migration[5.1]
  def up
    change_column :tags, :name, :citext
  end

  def down
    change_column :tags, :name, :string
  end
end

class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.references :created_by, references: :user

      t.timestamps
    end
  end
end

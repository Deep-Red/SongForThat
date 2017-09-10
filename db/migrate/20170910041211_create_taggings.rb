class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.references :song, foreign_key: true
      t.references :tag, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.integer :approvals
      t.integer :disapprovals
      t.numeric :score

      t.timestamps
    end
  end
end

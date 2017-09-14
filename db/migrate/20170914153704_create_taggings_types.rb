class CreateTaggingsTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings_types do |t|
      t.references :tagging, foreign_key: true
      t.references :type, foreign_key: true

      t.timestamps
    end
  end
end

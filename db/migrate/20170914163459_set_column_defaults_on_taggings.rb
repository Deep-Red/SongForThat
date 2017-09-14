class SetColumnDefaultsOnTaggings < ActiveRecord::Migration[5.1]
  def change
    change_column_default :taggings, :approvals, 0
    change_column_default :taggings, :disapprovals, 0
    change_column_default :taggings, :score, 0
  end
end

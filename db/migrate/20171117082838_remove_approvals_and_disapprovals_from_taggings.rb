class RemoveApprovalsAndDisapprovalsFromTaggings < ActiveRecord::Migration[5.1]
  def change
    remove_column :taggings, :approvals, :integer
    remove_column :taggings, :disapprovals, :integer
  end
end

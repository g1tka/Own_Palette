class AddBlockToRelationship < ActiveRecord::Migration[6.1]
  def change
    add_column :relationships, :blocker_id, :integer
    add_column :relationships, :blocked_id, :integer
  end
end

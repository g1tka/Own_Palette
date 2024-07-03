class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|

      t.integer :user_id, null: false
      t.integer :post_id, null: false
      t.string :body, null: false
      t.integer :stance, null: false
      t.timestamps
    end
  end
end

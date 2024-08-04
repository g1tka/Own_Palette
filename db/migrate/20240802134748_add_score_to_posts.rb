class AddScoreToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :score, :decimal, precision: 5, scale: 3
  end
end

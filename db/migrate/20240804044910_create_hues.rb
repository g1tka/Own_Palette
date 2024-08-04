class CreateHues < ActiveRecord::Migration[6.1]
  def change
    create_table :hues do |t|
      t.integer :red
      t.integer :green
      t.integer :blue
      t.float :score
      t.float :pixel_fraction
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end
  end
end

class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.decimal :price, precision: 8, scale: 2
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :products, [:user_id, :created_at]
    add_foreign_key :products, :users
  end
end

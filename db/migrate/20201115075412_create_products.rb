class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t| 
      t.string :title,null: false
      t.text :text
      t.string :github_uri
      t.string :product_uri
      t.integer :likes_count
      t.references :user,foreign_key: true
      t.timestamps
    end
  end
end

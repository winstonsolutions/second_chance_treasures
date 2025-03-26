class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :condition
      t.integer :quantity
      t.string :sku
      t.boolean :is_featured

      t.timestamps
    end
  end
end

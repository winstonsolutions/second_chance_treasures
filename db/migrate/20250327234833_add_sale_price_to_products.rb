class AddSalePriceToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :sale_price, :decimal, precision: 10, scale: 2
    add_column :products, :on_sale, :boolean, default: false
  end
end
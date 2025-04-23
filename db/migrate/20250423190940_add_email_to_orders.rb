class AddEmailToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :email, :string
  end
end

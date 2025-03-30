class AddAddressToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :address_line1, :string
    add_column :users, :address_line2, :string
    add_column :users, :city, :string
    add_column :users, :postal_code, :string
    add_reference :users, :province, foreign_key: true
  end
end
class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'new'
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :tax_amount, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.string :stripe_payment_id
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.references :province, null: false, foreign_key: true
      t.string :postal_code

      t.timestamps
    end
  end
end
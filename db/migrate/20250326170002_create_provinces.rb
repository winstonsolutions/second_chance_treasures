class CreateProvinces < ActiveRecord::Migration[7.2]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :code
      t.decimal :gst, precision: 5, scale: 2, default: 0
      t.decimal :pst, precision: 5, scale: 2, default: 0
      t.decimal :hst, precision: 5, scale: 2, default: 0

      t.timestamps
    end
  end
end
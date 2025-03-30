ActiveAdmin.register Order do
  permit_params :status

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :total
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: %w[new paid shipped]
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :subtotal
      row :tax_amount
      row :total
      row :stripe_payment_id
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price_at_time
        column :subtotal do |item|
          number_to_currency(item.price_at_time * item.quantity)
        end
      end
    end
  end
end
ActiveAdmin.register Product do
  permit_params :title, :description, :price, :condition, :quantity, :sku, :is_featured, :image

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :price
      f.input :condition, as: :select, collection: ['Like New', 'Good', 'Fair', 'Poor']
      f.input :quantity
      f.input :sku
      f.input :is_featured
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :price
      row :condition
      row :quantity
      row :sku
      row :is_featured
      row :image do |product|
        image_tag product.image.variant(resize_to_limit: [300, 300]) if product.image.attached?
      end
    end
  end
end
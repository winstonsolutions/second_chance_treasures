ActiveAdmin.register Product do
  permit_params :title, :description, :price, :quantity, :on_sale, :sale_price,
                :images, category_ids: []

  index do
    selectable_column
    id_column
    column :title
    column :price do |product|
      number_to_currency product.price
    end
    column :quantity
    column :categories
    column :on_sale
    column :sale_price do |product|
      number_to_currency product.sale_price if product.sale_price.present?
    end
    column "Images" do |product|
      ul do
        product.images.each do |img|
          li image_tag(img.variant(resize_to_limit: [100, 100])) if img.attached?
        end
      end
    end
    actions
  end

  filter :title
  filter :price
  filter :categories
  filter :on_sale
  filter :created_at

  form do |f|
    f.inputs "Product Details" do
      f.input :title
      f.input :description, as: :text
      f.input :price
      f.input :quantity
      f.input :categories, as: :select, collection: Category.all
      f.input :on_sale
      f.input :sale_price
      f.input :images, as: :file, input_html: { multiple: true }, hint: "可以选择多张图片"
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :price do |product|
        number_to_currency product.price
      end
      row :quantity
      row :categories
      row :on_sale
      row :sale_price do |product|
        number_to_currency product.sale_price if product.sale_price.present?
      end
      row :created_at
      row :updated_at
      row :images do |product|
        ul do
          product.images.each do |img|
            li image_tag(img.variant(resize_to_limit: [200, 200])) if img.attached?
          end
        end
      end
    end
  end
end
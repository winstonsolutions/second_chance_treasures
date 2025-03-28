ActiveAdmin.register Product do
  permit_params :title, :description, :price, :condition, :quantity, :sku,
                :is_featured, :on_sale, :sale_price, :image,
                { images: [] }, { category_ids: [] }

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
      ul class: 'image-list' do
        product.images.each do |img|
          begin
            li class: 'image-item' do
              image_tag img.variant(:thumb)
            end
          rescue StandardError => e
            Rails.logger.error "Error displaying image: #{e.message}"
            content_tag(:span, "图片加载错误")
          end
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
    f.semantic_errors # 显示验证错误

    f.inputs 'Product Details' do
      f.input :title
      f.input :description
      f.input :price
      f.input :condition, as: :select, collection: ['Like New', 'Good', 'Fair', 'Poor']
      f.input :quantity
      f.input :sku, hint: 'Unique identifier for the product'
      f.input :is_featured
      f.input :on_sale
      f.input :sale_price
      f.input :categories, as: :check_boxes
      f.input :image, as: :file, hint: 'Main product image'
      f.input :images, as: :file, input_html: { multiple: true }, hint: 'Additional product images'
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
      row :condition
      row :quantity
      row :sku
      row :categories
      row :on_sale
      row :sale_price do |product|
        number_to_currency product.sale_price if product.sale_price.present?
      end
      row :created_at
      row :updated_at
      row :images do |product|
        ul class: 'image-list' do
          product.images.each do |img|
            begin
              li class: 'image-item' do
                image_tag img.variant(:medium).processed
              end
            rescue StandardError => e
              Rails.logger.error "Error displaying image: #{e.message}"
              content_tag(:span, "图片加载错误")
            end
          end
        end
      end
      row :image do |product|
        if product.image.attached?
          begin
            image_tag product.image.variant(:medium).processed, style: 'max-width: 300px'
          rescue StandardError => e
            Rails.logger.error "Error displaying image: #{e.message}"
            content_tag(:span, "图片加载错误")
          end
        end
      end
    end
  end

  controller do
    def create
      super do |success, failure|
        success.html do
          flash[:notice] = "Product was successfully created"
          redirect_to admin_product_path(resource) and return
        end

        failure.html do
          flash.now[:error] = resource.errors.full_messages.join(", ")
          render :new and return
        end
      end
    end

    def update
      super do |success, failure|
        success.html do
          flash[:notice] = "Product was successfully updated"
          redirect_to admin_product_path(resource)
        end
      end
    end
  end
end
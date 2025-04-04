ActiveAdmin.register Category do
  # Permit parameters that can be edited through the admin interface
  permit_params :name, :description

  # 禁用过滤器以避免影响我们的集合
  config.filters = false

  # 完全覆盖index方法
  controller do
    def index
      # 这个方法会被覆盖
      index! do |format|
        # 在这里替换collection变量
        @collection = Category.page(params[:page]).per(1000)
        format.html
      end
    end
  end

  # 配置 index 视图
  index do
    selectable_column
    id_column
    column :name
    column :description do |category|
      truncate(category.description, length: 100) if category.description.present?
    end
    column :products do |category|
      link_to "#{category.products.count} products", admin_products_path(q: { categories_id_eq: category.id })
    end
    column :created_at
    column :updated_at
    actions
  end

  # Form for creating/editing categories
  form do |f|
    f.inputs "Category Details" do
      f.input :name
      f.input :description, as: :text
    end
    f.actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Products" do
      table_for category.products do
        column :id
        column :title do |product|
          link_to product.title, admin_product_path(product)
        end
        column :price do |product|
          number_to_currency(product.price)
        end
        column :condition
        column :quantity
      end
    end
  end
end
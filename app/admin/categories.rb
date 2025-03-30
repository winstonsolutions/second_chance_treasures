ActiveAdmin.register Category do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :name

  # 移除 controller 块，改用 collection_action
  collection_action :index, method: :get do
    @categories = Category.page(params[:page]).per(10)
  end

  # 自定义列表显示
  index pagination_total: false do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  # 只添加我们需要的过滤器
  filter :name
  filter :created_at
  filter :updated_at

  # 表单配置
  form do |f|
    f.inputs "Category Details" do
      f.input :name
    end
    f.actions
  end

  # 详情页配置
  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end
end

ActiveAdmin.register Page do
  permit_params :title, :slug, :content, :meta_title, :meta_description, :published

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :published
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :slug
  filter :published
  filter :created_at

  form do |f|
    f.inputs "Page Details" do
      f.input :title
      f.input :slug, hint: "用于URL的唯一标识符，例如 'about' 或 'contact'"
      f.input :content, as: :text
      f.input :meta_title
      f.input :meta_description
      f.input :published
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |page|
        raw page.content
      end
      row :meta_title
      row :meta_description
      row :published
      row :created_at
      row :updated_at
    end
  end
end
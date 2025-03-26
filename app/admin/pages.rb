ActiveAdmin.register Page do
  permit_params :title, :slug, :content

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :content, as: :text
    end
    f.actions
  end
end
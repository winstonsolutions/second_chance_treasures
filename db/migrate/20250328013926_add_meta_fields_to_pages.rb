class AddMetaFieldsToPages < ActiveRecord::Migration[7.2]
  def change
    add_column :pages, :meta_title, :string
    add_column :pages, :meta_description, :text
    add_column :pages, :published, :boolean, default: false
  end
end

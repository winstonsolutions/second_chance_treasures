ActiveAdmin.register Province do
  # Permit parameters that can be edited through the admin interface
  permit_params :name, :code, :gst, :pst, :hst

  # Disable filters to avoid affecting our collection
  config.filters = false

  # Override index method completely
  controller do
    def index
      # This method will be overridden
      index! do |format|
        # Replace collection variable here
        @collection = Province.page(params[:page]).per(1000)
        format.html
      end
    end
  end

  # Configure index view
  index do
    selectable_column
    id_column
    column :name
    column :code
    column :gst do |province|
      number_to_percentage(province.gst, precision: 2)
    end
    column :pst do |province|
      number_to_percentage(province.pst, precision: 2)
    end
    column :hst do |province|
      number_to_percentage(province.hst, precision: 2)
    end
    column :users do |province|
      province.users.count
    end
    column :created_at
    column :updated_at
    actions
  end

  # Form for creating/editing provinces
  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :code
      f.input :gst, label: "GST (%)"
      f.input :pst, label: "PST (%)"
      f.input :hst, label: "HST (%)"
    end
    f.actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :code
      row :gst do |province|
        number_to_percentage(province.gst, precision: 2)
      end
      row :pst do |province|
        number_to_percentage(province.pst, precision: 2)
      end
      row :hst do |province|
        number_to_percentage(province.hst, precision: 2)
      end
      row :created_at
      row :updated_at
    end

    panel "Users in this Province" do
      para "Total users: #{province.users.count}"
      table_for province.users.limit(10) do
        column :id
        column :email
        column :name do |user|
          [user.first_name, user.last_name].compact.join(' ')
        end
      end
      para "Showing first 10 users" if province.users.count > 10
    end
  end
end
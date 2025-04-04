class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # Override the update method to ensure address fields are properly saved
  def update
    # If password was not provided, remove it from params to allow update without password
    if params[:user][:password].blank?
      # If password is blank, allow updating without current password
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      params[:user].delete(:current_password)

      # Update without requiring the current password
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      # Direct database update skipping password validation
      updated = resource.update(account_update_params)

      # Handle update result
      if updated
        set_flash_message_for_update(resource, prev_unconfirmed_email)
        bypass_sign_in resource, scope: resource_name
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      # If password is provided, follow the normal Devise update process
      super
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name,
      :last_name,
      :phone,
      :address_line1,
      :address_line2,
      :city,
      :postal_code,
      :province_id
    ])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name,
      :last_name,
      :phone,
      :address_line1,
      :address_line2,
      :city,
      :postal_code,
      :province_id
    ])
  end

  # Override the path after updating
  def after_update_path_for(resource)
    my_account_path
  end
end
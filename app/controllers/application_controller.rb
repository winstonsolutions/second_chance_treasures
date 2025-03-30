class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :initialize_cart_service
  before_action :load_categories

  private

  def initialize_cart_service
    @cart_service = CartService.new(session)
  end

  def load_categories
    @categories = Category.all
  end
end

class CartController < ApplicationController
  before_action :initialize_cart_service

  def show
    @cart_items = @cart_service.items
  end

  def add
    @cart_service.add_item(params[:product_id], params[:quantity])
    redirect_back fallback_location: products_path, notice: 'Item added to cart'
  end

  def update
    @cart_service.update_quantity(params[:product_id], params[:quantity])
    redirect_to cart_path, notice: 'Cart updated'
  end

  def remove
    @cart_service.remove_item(params[:product_id])
    redirect_to cart_path, notice: 'Item removed from cart'
  end

  private

  def initialize_cart_service
    @cart_service = CartService.new(session)
  end
end
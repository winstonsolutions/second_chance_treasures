class CartsController < ApplicationController
  # 添加商品到购物车的方法
  def add
    @product = Product.find(params[:id])
    quantity = params[:quantity].to_i || 1

    cart_service = CartService.new(session)
    cart_service.add_item(@product.id, quantity)

    redirect_to @product, notice: "#{@product.title} has been added to your cart"
  end

  # 查看购物车的方法
  def show
    @cart_service = CartService.new(session)
    @cart_items = @cart_service.items
    @total = @cart_service.total
  end

  # 清空购物车的方法
  def clear
    cart_service = CartService.new(session)
    cart_service.clear
    redirect_to cart_path, notice: "Cart has been cleared"
  end

  def update
    cart_service = CartService.new(session)
    cart_service.update_quantity(params[:id], params[:quantity])
    redirect_to cart_path, notice: "Cart updated successfully"
  end

  def remove
    cart_service = CartService.new(session)
    cart_service.remove_item(params[:id])
    redirect_to cart_path, notice: "Item removed from cart"
  end
end
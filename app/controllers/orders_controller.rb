class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_cart_service

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    @order = build_order

    if @order.save
      @cart_service.clear
      redirect_to order_path(@order), notice: 'Order was successfully created.'
    else
      redirect_to cart_path, alert: 'Could not create order.'
    end
  end

  private

  def build_order
    order = current_user.orders.build

    @cart_service.items.each do |item|
      order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end

    order
  end

  def initialize_cart_service
    @cart_service = CartService.new(session)
  end
end
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_cart_service

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    @order = build_order

    # Pre-fill address if user has one
    if current_user.province_id.present?
      @order.address_line1 = current_user.address_line1
      @order.address_line2 = current_user.address_line2
      @order.city = current_user.city
      @order.postal_code = current_user.postal_code
      @order.province_id = current_user.province_id
    end

    @order.calculate_totals
  end

  def create
    @order = build_order

    # 如果用户已有地址，使用用户的地址信息
    if current_user.address_line1.present? && current_user.province_id.present?
      @order.assign_attributes(
        address_line1: current_user.address_line1,
        address_line2: current_user.address_line2,
        city: current_user.city,
        postal_code: current_user.postal_code,
        province_id: current_user.province_id
      )
    # 否则使用提交的地址信息
    elsif order_params.present?
      @order.assign_attributes(order_params)
    end

    @order.calculate_totals

    if @order.save
      @cart_service.clear
      redirect_to order_path(@order), notice: 'Order was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def build_order
    order = current_user.orders.build

    @cart_service.items.each do |item|
      order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        price_at_time: item[:product].price
      )
    end

    order
  end

  def initialize_cart_service
    @cart_service = CartService.new(session)
  end

  def order_params
    params.require(:order).permit(
      :address_line1,
      :address_line2,
      :city,
      :postal_code,
      :province_id
    )
  rescue ActionController::ParameterMissing
    {}
  end
end
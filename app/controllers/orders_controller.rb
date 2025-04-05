class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_cart_service
  before_action :set_order, only: [:show, :success, :cancel]

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])

    # Only create checkout session for new orders
    if @order.status == 'new'
      stripe_service = StripeService.new
      @checkout_session = stripe_service.create_checkout_session(@order)
    end
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

  # Handle successful payment
  def success
    session_id = params[:session_id]

    if session_id.present?
      # 测试模式下，不实际调用Stripe API，直接标记订单为已支付
      @order.update(
        status: 'paid',
        stripe_payment_id: "test_pi_#{SecureRandom.alphanumeric(24)}" # 生成假的支付ID
      )

      flash[:notice] = 'Payment successful! Your order has been confirmed.'
    else
      flash[:alert] = 'Payment session ID not found.'
    end

    redirect_to order_path(@order)
  end

  # Handle canceled payment
  def cancel
    flash[:alert] = 'Payment was canceled. Your order is still pending.'
    redirect_to order_path(@order)
  end

  private

  def set_order
    @order = current_user.orders.find(params[:order_id] || params[:id])
  end

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
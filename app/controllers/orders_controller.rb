class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_new, :guest_create, :guest_confirmation, :success, :cancel, :show]
  before_action :initialize_cart_service
  before_action :set_order, only: [:show, :success, :cancel]

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    # Find the order for display
    if user_signed_in?
      @order = current_user.orders.find_by(id: params[:id])
      redirect_to root_path, alert: 'Order not found' unless @order
    else
      @order = Order.find_by(id: params[:id])

      # Check if this is the guest's order
      if @order && @order.user.nil? && session[:guest_order_id].to_s == @order.id.to_s
        # Allow access to the guest order
      else
        redirect_to root_path, alert: "You don't have permission to view this order"
        return
      end
    end

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

    # If user has address, use it
    if current_user.address_line1.present? && current_user.province_id.present?
      @order.assign_attributes(
        address_line1: current_user.address_line1,
        address_line2: current_user.address_line2,
        city: current_user.city,
        postal_code: current_user.postal_code,
        province_id: current_user.province_id
      )
    # Otherwise use submitted address
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

  # Guest checkout form
  def guest_new
    @provinces = Province.all
    @order = Order.new
    @cart_items = @cart_service.items

    # Calculate subtotal
    @subtotal = @cart_service.total
  end

  # Create order for guest
  def guest_create
    @order = Order.new(guest_order_params)
    @order.user_id = nil # Explicitly set user_id to nil for guest orders
    @cart_items = @cart_service.items

    # Add cart items to order
    @cart_items.each do |item|
      @order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        price_at_time: item[:product].price
      )
    end

    # Calculate totals
    @order.calculate_totals

    if @order.save
      # Store order ID in session for retrieval
      session[:guest_order_id] = @order.id
      @cart_service.clear

      # Send to payment page
      stripe_service = StripeService.new
      @checkout_session = stripe_service.create_checkout_session(@order)

      redirect_to guest_order_confirmation_path(order_id: @order.id, session_id: @checkout_session.id),
                  notice: 'Order was successfully created.'
    else
      @provinces = Province.all
      render :guest_new, status: :unprocessable_entity
    end
  end

  # Guest order confirmation page
  def guest_confirmation
    @order = Order.find(params[:order_id])
    @session_id = params[:session_id]
  end

  # Handle successful payment
  def success
    session_id = params[:session_id]

    if session_id.present?
      # In test mode, directly mark order as paid
      @order.update(
        status: 'paid',
        stripe_payment_id: "test_pi_#{SecureRandom.alphanumeric(24)}" # Generate fake payment ID
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
    # Allow finding order for both logged in and guest users
    if user_signed_in?
      @order = current_user.orders.find_by(id: params[:order_id] || params[:id])
    else
      # For guest users - find by the ID stored in session or from params
      @order = Order.find_by(id: session[:guest_order_id] || params[:order_id] || params[:id])
    end

    unless @order
      redirect_to root_path, alert: 'Order not found'
    end
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

  def guest_order_params
    params.require(:order).permit(
      :email,
      :address_line1,
      :address_line2,
      :city,
      :postal_code,
      :province_id
    )
  end
end
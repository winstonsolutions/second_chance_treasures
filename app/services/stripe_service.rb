require 'ostruct'
require 'securerandom'

class StripeService
  def initialize
    # Using Stripe test mode API key (in production, this should be fetched from environment variables)
    Stripe.api_key = 'sk_test_51OxTCsDMcLx0NdKkHJTrpWlJYtAR1t7YfAOEhGv9KaJQUVlWMPMc2Bq1O0iYSngFXmxQovleMZkOKpECM7tHgGLS00PoMPxhDu'
    @test_mode = true # Always use test mode
  end

  def create_checkout_session(order)
    # Always return a mock checkout session
    mock_checkout_session(order)
  end

  def retrieve_payment_intent(session_id)
    # Always return a mock payment intent
    mock_payment_intent
  end

  private

  def mock_checkout_session(order)
    # Create a simple structure to mock a Stripe checkout session
    session_id = "test_cs_#{SecureRandom.hex(12)}"

    # Determine customer email - use order email for guest orders
    customer_email = order.user ? order.user.email : order.email

    OpenStruct.new(
      id: session_id,
      client_reference_id: order.id.to_s,
      payment_status: 'unpaid',
      payment_intent: "test_pi_#{SecureRandom.hex(12)}",
      customer_email: customer_email
    )
  end

  def mock_payment_intent
    # Create a simple structure to mock a payment intent
    OpenStruct.new(
      id: "test_pi_#{SecureRandom.hex(12)}",
      status: 'succeeded',
      amount: 1000,
      currency: 'usd',
      client_secret: "test_pi_secret_#{SecureRandom.hex(12)}"
    )
  end
end
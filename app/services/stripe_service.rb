require 'ostruct'
require 'securerandom'

class StripeService
  def initialize
    # 使用Stripe测试模式API密钥 (在生产中应该从环境变量获取)
    Stripe.api_key = 'sk_test_51OxTCsDMcLx0NdKkHJTrpWlJYtAR1t7YfAOEhGv9KaJQUVlWMPMc2Bq1O0iYSngFXmxQovleMZkOKpECM7tHgGLS00PoMPxhDu'
    @test_mode = true # 始终使用测试模式
  end

  def create_checkout_session(order)
    # 始终返回模拟的结账会话
    mock_checkout_session(order)
  end

  def retrieve_payment_intent(session_id)
    # 始终返回模拟的支付意向
    mock_payment_intent
  end

  private

  def mock_checkout_session(order)
    # 创建一个简单的结构来模拟Stripe结账会话
    session_id = "test_cs_#{SecureRandom.hex(12)}"

    OpenStruct.new(
      id: session_id,
      client_reference_id: order.id.to_s,
      payment_status: 'unpaid',
      payment_intent: "test_pi_#{SecureRandom.hex(12)}"
    )
  end

  def mock_payment_intent
    # 创建一个简单的结构来模拟支付意向
    OpenStruct.new(
      id: "test_pi_#{SecureRandom.hex(12)}",
      status: 'succeeded',
      amount: 1000,
      currency: 'usd',
      client_secret: "test_pi_secret_#{SecureRandom.hex(12)}"
    )
  end
end
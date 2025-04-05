class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def webhook
    payload = request.body.read

    # 测试环境下，简化webhook处理，不验证签名
    begin
      event = JSON.parse(payload)
      event_object = event['data']['object']

      if event['type'] == 'checkout.session.completed'
        # 找到对应的订单
        if event_object['payment_status'] == 'paid'
          client_reference_id = event_object['client_reference_id']
          payment_intent = event_object['payment_intent']

          order = Order.find_by(id: client_reference_id)

          if order && order.status == 'new'
            order.update(
              status: 'paid',
              stripe_payment_id: payment_intent
            )
          end
        end
      end
    rescue JSON::ParserError => e
      # 无效的JSON
      head :bad_request
      return
    end

    head :ok
  end
end
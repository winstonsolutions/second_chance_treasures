class CartService
  def initialize(session)
    @session = session
    @session[:cart] ||= {}
  end

  def add_item(product_id, quantity = 1)
    @session[:cart][product_id.to_s] ||= 0
    @session[:cart][product_id.to_s] += quantity.to_i
  end

  def update_quantity(product_id, quantity)
    if quantity.to_i > 0
      @session[:cart][product_id.to_s] = quantity.to_i
    else
      remove_item(product_id)
    end
  end

  def remove_item(product_id)
    @session[:cart].delete(product_id.to_s)
  end

  def clear
    @session[:cart] = {}
  end

  def items
    @session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      {
        product: product,
        quantity: quantity,
        subtotal: product.price * quantity
      }
    end
  end

  def total
    items.sum { |item| item[:subtotal] }
  end
end
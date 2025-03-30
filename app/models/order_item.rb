class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_at_time, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_price_at_time, on: :create

  # Add ransackable_attributes method to whitelist searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "order_id", "price_at_time", "product_id", "quantity", "updated_at"]
  end

  # Add ransackable_associations method if needed
  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end

  private

  def set_price_at_time
    self.price_at_time = product.price if product
  end
end
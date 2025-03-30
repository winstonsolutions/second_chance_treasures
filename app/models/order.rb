class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, inclusion: { in: %w[new paid shipped] }
  validates :subtotal, :tax_amount, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true

  # Add ransackable_attributes method to whitelist searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    [
      "city",
      "created_at",
      "id",
      "status",
      "stripe_payment_id",
      "subtotal",
      "tax_amount",
      "total",
      "updated_at"
    ]
  end

  # Add ransackable_associations method to whitelist searchable associations
  def self.ransackable_associations(auth_object = nil)
    ["order_items", "products", "province", "user"]
  end

  def calculate_totals
    self.subtotal = order_items.sum { |item| item.price_at_time * item.quantity }
    self.tax_amount = calculate_tax
    self.total = subtotal + tax_amount
  end

  def total
    order_items.sum { |item| item.quantity * item.price }
  end

  private

  def calculate_tax
    return 0 unless province
    subtotal * (
      (province.gst + province.pst + province.hst) / 100
    )
  end
end
class Province < ApplicationRecord
  has_many :users
  has_many :orders

  validates :name, :code, presence: true, uniqueness: true
  validates :gst, :pst, :hst,
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  # Add ransackable_attributes method to whitelist searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["code", "created_at", "gst", "hst", "id", "name", "pst", "updated_at"]
  end
end
class Product < ApplicationRecord
    has_one_attached :image

    has_many :product_categories, dependent: :destroy
    has_many :categories, through: :product_categories
    
    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :condition, presence: true
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :sku, presence: true, uniqueness: true
  end
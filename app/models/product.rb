class Product < ApplicationRecord
    has_one_attached :image
    has_many_attached :images

    has_many :product_categories, dependent: :destroy
    has_many :categories, through: :product_categories

    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :condition, presence: true
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :sku, presence: true, uniqueness: true

    # 定义可搜索属性
    def self.ransackable_attributes(auth_object = nil)
        ["condition", "created_at", "description", "id", "is_featured",
         "on_sale", "price", "quantity", "sale_price", "sku", "title", "updated_at"]
    end

    # 如果你使用了关联搜索（比如通过category），还需要添加：
    def self.ransackable_associations(auth_object = nil)
        ["category"]
    end
end
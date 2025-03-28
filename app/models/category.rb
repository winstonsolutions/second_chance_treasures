class Category < ApplicationRecord
    has_many :product_categories, dependent: :destroy
    has_many :products, through: :product_categories

    validates :name, presence: true, uniqueness: true

    # 定义可搜索属性
    def self.ransackable_attributes(auth_object = nil)
        ["id", "name", "created_at", "updated_at"]
    end

    # 定义可搜索的关联
    def self.ransackable_associations(auth_object = nil)
        ["product_categories", "products"]
    end
end
class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category

  # 定义可搜索属性
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "id", "product_id", "updated_at"]
  end

  # 定义可搜索的关联
  def self.ransackable_associations(auth_object = nil)
    ["category", "product"]
  end
end

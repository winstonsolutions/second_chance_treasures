class Product < ApplicationRecord
    has_one_attached :image do |attachable|
      attachable.variant :thumb, resize_to_fit: [100, 100]
      attachable.variant :medium, resize_to_fit: [300, 300]
      attachable.variant :large, resize_to_fit: [800, 800]
    end

    has_many_attached :images do |attachable|
      attachable.variant :thumb, resize_to_fit: [100, 100]
      attachable.variant :medium, resize_to_fit: [300, 300]
      attachable.variant :large, resize_to_fit: [800, 800]
    end

    has_many :product_categories, dependent: :destroy
    has_many :categories, through: :product_categories

    validates :title, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
    validates :condition, presence: true
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :sku, presence: true, uniqueness: true

    # 添加图片验证
    validate :acceptable_images

    # 定义可搜索属性
    def self.ransackable_attributes(auth_object = nil)
        ["condition", "created_at", "description", "id", "is_featured",
         "on_sale", "price", "quantity", "sale_price", "sku", "title", "updated_at", "images"]
    end

    # 定义可搜索的关联
    def self.ransackable_associations(auth_object = nil)
        ["categories", "product_categories"]  # 添加所有需要搜索的关联
    end

    private

    def acceptable_images
      return unless images.attached?

      images.each do |image|
        unless image.blob.byte_size <= 5.megabyte
          errors.add(:images, "太大了（最大5MB）")
        end

        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(image.content_type)
          errors.add(:images, "必须是JPEG或PNG格式")
        end
      end
    end
end
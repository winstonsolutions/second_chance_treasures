class Page < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true
  validates :meta_title, length: { maximum: 60 }, allow_blank: true
  validates :meta_description, length: { maximum: 160 }, allow_blank: true

  # 定义可搜索属性
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "meta_description", "meta_title",
     "published", "slug", "title", "updated_at"]
  end

  # 如果有关联需要搜索，也可以添加
  def self.ransackable_associations(auth_object = nil)
    []
  end
end

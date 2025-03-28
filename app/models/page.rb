class Page < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  # 定义可搜索属性
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "slug", "title", "updated_at"]
  end

  # 如果有关联需要搜索，也可以添加
  def self.ransackable_associations(auth_object = nil)
    []
  end
end

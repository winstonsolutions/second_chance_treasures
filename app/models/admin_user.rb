class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # 定义可搜索属性 - 只包含安全的属性
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "updated_at"]  # 移除了敏感信息
  end

  # 如果有关联需要搜索，也可以添加
  def self.ransackable_associations(auth_object = nil)
    []
  end
end

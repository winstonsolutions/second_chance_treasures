class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  # Make address_line1, city, postal_code, and province_id optional during registration
  validates :address_line1, :city, :postal_code, :province_id, presence: true, on: :update

  def self.ransackable_attributes(auth_object = nil)
    ["email", "first_name", "last_name", "created_at", "id", "address_line1", "city", "postal_code", "province_id"]
  end
end

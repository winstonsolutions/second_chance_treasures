class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :province, optional: true
  has_many :orders, dependent: :destroy

  # Validations for address fields
  # These are not required during sign up but should be present when updating address info
  validates :address_line1, :city, :postal_code, :province_id,
            presence: true,
            on: :update,
            unless: -> { address_line1.blank? && city.blank? && postal_code.blank? && province_id.blank? }

  def self.ransackable_attributes(auth_object = nil)
    ["email", "first_name", "last_name", "created_at", "id", "address_line1", "city", "postal_code", "province_id"]
  end
end

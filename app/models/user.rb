class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end

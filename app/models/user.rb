class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self


  def avatar_url
    return nil unless avatar.attached?
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: false)
  end

  def profile_json
    {
      id: id,
      email: email,
      name: name,
      bio: bio,
      avatar_url: avatar_url,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end

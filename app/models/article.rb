class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many_attached :files, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true

  #optional helper to get the count of likes
  def likes_count
    likes.count
  end
  def file_urls
    files.map{ |file| Rails.application.routes.url_helpers.url_for(file)} if files.attached?
  end

end

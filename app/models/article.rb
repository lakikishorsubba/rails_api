class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  #optional helper to get the count of likes
  def likes_count
    likes.count
  end

end

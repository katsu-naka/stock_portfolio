class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes, dependent: :destroy
  
  def like_user(user_id)
    likes.find_by(user_id: usr_id)
  end
end

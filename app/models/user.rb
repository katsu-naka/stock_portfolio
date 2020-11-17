class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments,dependent: :destroy
  
  NAME_REGEX = /\A[ぁ-んァ-ン一-龥]+\z/.freeze
  NAME_KANA_REGEX = /\A[ァ-ヶー－]+\z/.freeze
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  
  with_options presence: true do
  validates :nickname
  validates :birth
  validates :first_name, format: { with: NAME_REGEX, message: 'は全角で入力してください' }
  validates :last_name, format: { with: NAME_REGEX, message: 'は全角で入力してください' }
  validates :first_name_kana, format: { with: NAME_KANA_REGEX, message: 'は全角カタカナで入力してください' }
  validates :last_name_kana, format: { with: NAME_KANA_REGEX, message: 'は全角カタカナで入力してください' }
  end
  validates :email, uniqueness: { case_sensitive: false }
  validates :profile, length: { maximum: 200, message: "は200文字以内で入力してください" }

  def liked_by?(product_id)
    likes.where(product_id: product_id).exists?
  end
end
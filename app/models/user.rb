class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments,dependent: :destroy
  has_many :contacts,dependent: :destroy
  has_one_attached :user_photo
  
  NAME_REGEX = /\A[ぁ-んァ-ン一-龥]+\z/.freeze
  NAME_KANA_REGEX = /\A[ァ-ヶー－]+\z/.freeze
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  PHONE_NUMBER_REGEX = /\A\d{11}\z/.freeze
  
  with_options presence: true do
  validates :nickname
  validates :first_name, format: { with: NAME_REGEX, message: 'は全角で入力してください' }
  validates :last_name, format: { with: NAME_REGEX, message: 'は全角で入力してください' }
  validates :first_name_kana, format: { with: NAME_KANA_REGEX, message: 'は全角カタカナで入力してください' }
  validates :last_name_kana, format: { with: NAME_KANA_REGEX, message: 'は全角カタカナで入力してください' }
  validates :birth
  validates :phone_number, format: { with: PHONE_NUMBER_REGEX, message: 'は半角数字のみ入力してください' }
end
validates :email, uniqueness: { case_sensitive: false }
validates :profile, length: { maximum: 200, message: "は200文字以内で入力してください" }

  def liked_by?(product_id)
    likes.where(product_id: product_id).exists?
  end
end
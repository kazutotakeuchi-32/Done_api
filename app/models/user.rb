
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable
  include DeviseTokenAuth::Concerns::User
  has_one_attached :image
  has_many :draft_learns
  has_many :learns
  def image_url
    image.attached? ? url_for(image) : nil
  end
end

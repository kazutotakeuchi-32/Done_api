
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable
  include DeviseTokenAuth::Concerns::User
  has_one_attached :image
  has_many :draft_learns
  has_many :learns
  has_many :relationships
  has_many :followings,through: :relationships, source: :follow
  has_many :reverse_of_relationships,class_name: 'Relationship',foreign_key: :follow_id
  has_many :followers,through: :reverse_of_relationships,source: :user

  def follow(other_user)
    if self.id != other_user.id
      self.relationships.find_or_create_by(follow_id:other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id:other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def image_url
    image.attached? ? url_for(image) : nil
  end

end

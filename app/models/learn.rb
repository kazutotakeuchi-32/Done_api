class Learn < ApplicationRecord
  belongs_to :user
  has_many :likes
  belongs_to :draft_learn
  scope :friends_data_with_me,->(qurey,user){where("user_id=? #{qurey}",user.id).order(created_at: "desc")}
  include GetLearnData
end

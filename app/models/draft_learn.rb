class DraftLearn < ApplicationRecord
  belongs_to :user
  has_one  :learn
  has_many :likes
  scope :friends_data_with_me,->(qurey,user){where("user_id=? #{qurey}",user.id).order(created_at: "desc")}
  include GetLearnData
end

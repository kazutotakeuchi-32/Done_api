class Like < ApplicationRecord
  belongs_to :user
  belongs_to :learn,optional: true
  belongs_to :draft_learn,optional: true
  validates :user_id, uniqueness: { scope: [:learn_id, :draft_learn_id] }

  def self.likeing_saves(likeing_contents,model,user)
    likeing_contents.each do |content|
      like=Like.new(model[:id]=> content.id,user_id:user.id)
      like.save
    end
  end

  def self.likeing_destroys(likeing_contents,model)
    likeing_contents.each do |content|
      like=Like.find_by(model[:id]=>content.id)
      like.destroy
    end
  end

end

class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room
  scope :entry_room_grouping,->(user,other_user){where("user_id=? or user_id=? ",user.id,other_user.id).group(:room_id).count}

  def self.entry_not_exist?(user,other_user)
    self.entry_room_grouping(user,other_user).values.max.to_i < 2
  end

  def self.get_room(user,other_user)
    self.entry_room_grouping(user,other_user).find{|k,v| v>=2}[0]
  end

end

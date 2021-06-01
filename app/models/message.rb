class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one   :read
end

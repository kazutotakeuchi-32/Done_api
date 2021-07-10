class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one   :read
  validates :message,presence: true
end

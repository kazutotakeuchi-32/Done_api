class Room < ApplicationRecord
  has_many :entries
  has_many :entry_to_users ,through: :entries, source: :user
  has_many :messages
  has_many :message_to_users ,through: :entries, source: :user
end

class DraftLearn < ApplicationRecord
  belongs_to :user
  has_one  :learn
  include GetLearnData
end

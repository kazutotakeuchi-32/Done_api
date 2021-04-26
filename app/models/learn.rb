class Learn < ApplicationRecord
 belongs_to :user
 belongs_to :draft_learn
 include GetLearnData
end

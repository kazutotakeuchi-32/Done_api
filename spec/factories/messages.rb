FactoryBot.define do
  factory :message do
    message{"test"}
    user_id{nil}
    room_id{nil}
  end
end

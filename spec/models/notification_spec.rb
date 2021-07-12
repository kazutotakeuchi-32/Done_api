require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:cuurent_user){FactoryBot.create(:test_user1)}
  let(:other_user){FactoryBot.create(:test_user2)}
  let(:room){Room.create}
  describe "通知" do
    before do
      @message=Message.create(user_id:cuurent_user.id,room_id:room.id,message:"test")
      @notification=Notification.create(sender_id:cuurent_user.id,receiver_id:other_user.id,message_id:@message.id,kind:"DM")
    end
    it "１つの通知は１人の送信者に紐づく" do
      expect(@notification.sender).to eq (cuurent_user)
    end
    it "１つの通知は１人の受信者に紐づく" do
      expect(@notification.receiver).to eq (other_user)
    end
    it "１つの通知は１メッセージに紐づく" do
      expect(@notification.message).to eq (@message)
    end
  end
end

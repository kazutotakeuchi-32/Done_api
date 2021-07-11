require 'rails_helper'

RSpec.describe Read, type: :model do
  describe "既読機能" do
    let(:cuurent_user){FactoryBot.create(:test_user1)}
    let(:room){Room.create()}
    before do
      2.times do |n|
        message=Message.create(message:"test#{n+1}",user_id:cuurent_user.id,room_id:room.id)
        Read.create(message_id:message.id,user_id:cuurent_user.id,room_id:room.id)
      end
    end
    it "ユーザは複数のreadを所有する事ができる" do
      expect(cuurent_user.reads.length).to eq(2)
    end
    it "1つのreadは１人のユーザに紐づく" do
      read=Read.all[0]
      user = User.find(read.user.id)
      expect(user).to eq read.user
    end
    it "1メッセージにつき1つの所有することができる。" do
      message=Message.all[0]
      read=Read.find(message.read.id)
      expect(read).to eq message.read
    end
    it "一つのreadは1メッセージに紐づく" do
      read=Read.all[0]
      message=Message.find(read.message.id)
      expect(read.message).to eq message
    end
  end
end

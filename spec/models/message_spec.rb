require 'rails_helper'
RSpec.describe Message, type: :model do
  describe "メッセージ投稿" do
    let(:cuurent_user){FactoryBot.create(:test_user1)}
    let(:other_user){FactoryBot.create(:test_user2)}
    let(:room){Room.create()}
    let(:message){FactoryBot.build(:message,user_id:cuurent_user.id,room_id:room.id)}
    before do
      cuurent_user.follow(other_user)
      other_user.follow(cuurent_user)
      [
        {user_id:cuurent_user.id,room_id:room.id},
        {user_id:other_user.id,room_id:room.id}
      ].each do |param|
        entry=Entry.new(param)
        entry.save
      end
    end
    context "投稿に成功" do
      it "全ての項目が入力されている" do
        expect(message).to be_valid
      end
      it "レコード数が増える" do
        expect{message.save}.to change(Message,:count).from(0).to(1)
      end
    end
    context "投稿に失敗" do
      it "空のオブジェクト" do
        message=Message.new
        message.valid?
        expect(message.errors.full_messages).to include("Messageを入力してください","Userを入力してください","Roomを入力してください")
      end
      it "messageが空" do
        message.message=nil
        message.valid?
        expect(message.errors.full_messages).to include("Messageを入力してください")
      end
      it "user_idがnil" do
        message.user_id=nil
        message.valid?
        expect(message.errors.full_messages).to include("Userを入力してください")
      end
      it "room_idがnil" do
        message.room_id=nil
        message.valid?
        expect(message.errors.full_messages).to include("Roomを入力してください")
      end
    end
  end
end

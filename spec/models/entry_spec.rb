require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:cuurent_user){FactoryBot.create(:test_user1)}
  let(:other_user1){FactoryBot.create(:test_user2)}
  describe "チャットルームを作成" do
    before do
      cuurent_user.follow(other_user1)
      other_user1.follow(cuurent_user)
    end
    context "相互フォロー" do
      context "チャットルームが存在しない場合" do
        it "trueになる" do
          expect(Entry.entry_not_exist?(cuurent_user,other_user1)).to  be_truthy
        end
        it "チャットルームを作成後、cuurent_user、other_user1のチャットルームが存在する" do
          if Entry.entry_not_exist?(cuurent_user,other_user1)
            room=Room.create()
            [
              {user_id:cuurent_user.id,room_id:room.id},
              {user_id:other_user1.id,room_id:room.id}
            ].each do |param|
              entry=Entry.new(param)
              entry.save
            end
            expect(expect(Entry.entry_not_exist?(cuurent_user,other_user1)).to  be_falsey)
          end
        end
      end
      context "チャットルームが存在する場合" do
        before do
          @room=Room.create()
          [
            {user_id:cuurent_user.id,room_id:@room.id},
            {user_id:other_user1.id,room_id:@room.id}
          ].each do |param|
            entry=Entry.new(param)
            entry.save
          end
        end
        it "falseになる" do
          expect(Entry.entry_not_exist?(cuurent_user,other_user1)).to  be_falsey
        end
        it "既存のチャットルームを取得する" do
          room_id= Entry.get_room(cuurent_user,other_user1)
          expect( room_id).to eq @room.id
        end
      end
    end
  end
end

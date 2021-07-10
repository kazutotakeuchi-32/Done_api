require 'rails_helper'

RSpec.describe "Messages", type: :request do
  describe "メッセージ投稿" do
    describe "POST /api/v1/users/:user_id/rooms/:room_id/messages" do
      let(:cuurent_user){FactoryBot.create(:test_user1)}
      let(:other_user){FactoryBot.create(:test_user2)}
      let(:room){Room.create()}
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
      context "投稿に成功する" do
        it "ステータスコード200が返って来る。" do
          post(api_v1_user_room_messages_path(cuurent_user.id,room.id),params:{message:{message:"test"}})
          expect(response.status).to eq 200
        end
        it "送信したメッセージがレスポンス値として返ってくる。" do
          post(api_v1_user_room_messages_path(cuurent_user.id,room.id),params:{message:{message:"test"}})
          res = JSON.parse(response.body)
          expect(res['data']['message']['message']).to eq "test"
        end
        it "メッセージ数が増える" do
          before_message_size = Message.all.size
          post(api_v1_user_room_messages_path(cuurent_user.id,room.id),params:{message:{message:"test"}})
          expect(before_message_size<Message.all.size).to be_truthy
        end
      end
      context "投稿に失敗する" do
        describe "messageが空" do
          it "ステータスコード401が返って来る。" do
            post(api_v1_user_room_messages_path(cuurent_user.id,room.id),params:{message:{message:nil}})
            expect(response.status).to eq 401
          end
          it "「投稿に失敗しました」というメッセージを含む" do
            post(api_v1_user_room_messages_path(cuurent_user.id,room.id),params:{message:{message:nil}})
            res = JSON.parse(response.body)
            expect(res['data']['message']).to eq "投稿に失敗しました。"
          end
          it "「Messageを入力をしてください」というメッセージを含む" do
            post(api_v1_user_room_messages_path(cuurent_user.id,room.id),params:{message:{message:nil}})
            res = JSON.parse(response.body)
            expect(res['data']['errors']).to include "Messageを入力してください"
          end
          it "メッセージ数が変わらない" do
            before_message_size = Message.all.size
            post(api_v1_user_room_messages_path(cuurent_user.id,room.id),params:{message:{message:nil}})
            expect(before_message_size==Message.all.size).to be_truthy
          end
        end
        describe "user_idがnil" do
          it "ActionController::UrlGenerationError" do
            begin
              post(api_v1_user_room_messages_path(nil,room.id),params:{message:{message:nil}})
            rescue => e
              expect(e.class).to eq ActionController::UrlGenerationError
            end
          end
        end
        describe "user_idに設定された値に紐づくユーザが存在しない" do
          it "ActionController::UrlGenerationError" do
            begin
              post(api_v1_user_room_messages_path(100,room.id),params:{message:{message:""}})
            rescue => e
              expect(e.class).to eq ActionController::UrlGenerationError
            end
          end
        end
        describe "room_idがnil" do
          it "ActionController::UrlGenerationError" do
            begin
              post(api_v1_user_room_messages_path(cuurent_user.id,nil),params:{message:{message:nil}})
            rescue => e
              expect(e.class).to eq ActionController::UrlGenerationError
            end
          end
        end
        describe "room_idに設定された値に紐づくチャットルームが存在しない" do
          it "ActionController::UrlGenerationError" do
            begin
              post(api_v1_user_room_messages_path(cuurent_user,100),params:{message:{message:""}})
            rescue => e
              expect(e.class).to eq ActionController::UrlGenerationError
            end
          end
        end
      end
    end
  end
end

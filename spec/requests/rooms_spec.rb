require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:cuurent_user){FactoryBot.create(:test_user1)}
  let(:other_user1){FactoryBot.create(:test_user2)}
  let(:other_user2){FactoryBot.create(:test_user3)}
  let(:other_user3){FactoryBot.create(:test_user4)}
  describe "チャットルーム" do
    def mutual_follow(user,other_user)
      user.follow(other_user)
      other_user.follow(user)
    end
    def template_messages(user,other_user,room)
      post(api_v1_user_room_messages_path(other_user.id,room),params:{message:{message:"初めまして、#{cuurent_user.name}さん、よろしくお願いします。"}})
      post(api_v1_user_room_messages_path(cuurent_user.id,room),params:{message:{message:"#{other_user.name}さん、こちらこそよろしくお願いします。"}})
    end
    before do
      [other_user1,other_user2,other_user3].each do |other_user|
        mutual_follow(cuurent_user,other_user)
        post(api_v1_entries_path,params:{user_id:cuurent_user.id,other_user:other_user.id})
        room_id=JSON.parse(response.body)['data']['room']
        template_messages(cuurent_user,other_user,room_id)
      end
    end
    describe "一覧" do
      describe "GET /api/v1/users/:user_id/rooms" do
        it "ステータスコードが200を返す" do
          get(api_v1_user_rooms_path(cuurent_user.id))
          expect(response.status).to eq 200
        end
        it "3つのチャットルームが存在する" do
          get(api_v1_user_rooms_path(cuurent_user.id))
          rooms_size=JSON.parse(response.body)['data']['rooms'].size
          expect(rooms_size).to eq 3
        end
        it "lastmessageはチャット内の最後のメッセージである。" do
          get(api_v1_user_rooms_path(cuurent_user.id))
          rooms=JSON.parse(response.body)['data']['rooms']
          users=[other_user3,other_user2,other_user1]
          rooms.each_with_index do |room,i|
            expect(room['lastMessages']['message']).to include "#{users[i].name}さん、こちらこそよろしくお願いします。"
          end
        end
        it "チャットルームの並び順はメッセージの降順で整列されている" do
          get(api_v1_user_rooms_path(cuurent_user.id))
          rooms=JSON.parse(response.body)['data']['rooms']
          users=[other_user3,other_user2,other_user1]
          rooms.each_with_index do |room,i|
            expect(room['user']['id']).to eq users[i].id
          end
        end
        it "一覧→詳細" do
          get(api_v1_user_rooms_path(cuurent_user.id))
          rooms=JSON.parse(response.body)['data']['rooms']
          rooms.each_with_index do |room|
            get(api_v1_user_room_path(cuurent_user.id,room['room']['room_id']))
            expect(response.status).to eq 200
          end
        end
        context "新しいメッセージが投稿された場合" do
          before do
            get(api_v1_user_rooms_path(cuurent_user.id))
            rooms=JSON.parse(response.body)['data']['rooms']
            room=rooms.find{|room|room['user']['id']==other_user1.id}
            post(api_v1_user_room_messages_path(other_user2.id, room['room']['room_id']),params:{message:{message:"息してる?"}})
          end
          it "新しくメッセージが投稿されたチャットルームが一番上に表示される" do
            get(api_v1_user_rooms_path(cuurent_user.id))
            rooms=JSON.parse(response.body)['data']['rooms']
            expect( rooms[0]['lastMessages']['message']).to eq "息してる?"
          end
        end
        context "一覧ページのデータ取得に失敗した場合" do
          it "user_idがnil" do
            begin
              get(api_v1_user_rooms_path(nil))
            rescue => e
              expect(e.class).to eq ActionController::UrlGenerationError
            end
          end
          it "user_idに紐づいたユーザが存在しない場合" do
            begin
              get(api_v1_user_rooms_path(100))
            rescue => e
              expect(e.class).to eq ActiveRecord::RecordNotFound
            end
          end
        end
      end
    end
    describe "詳細" do
      describe "GET /api/v1/users/:user_id/rooms/:id" do
        subject{get(api_v1_user_rooms_path(cuurent_user.id))}
        it "ステータスコード200が返って来る" do
          subject
          room=JSON.parse(response.body)['data']['rooms'][0]
          get(api_v1_user_room_path(cuurent_user.id,room['room']['room_id']))
          expect(response.status).to eq 200
        end
        it "各チャットルームには2つのメッセージが存在する。" do
          subject
          rooms=JSON.parse(response.body)['data']['rooms']
          rooms.each_with_index do |room|
            get(api_v1_user_room_path(cuurent_user.id,room['room']['room_id']))
            res=JSON.parse(response.body)
            expect(res['data']['messages'].size).to eq 2
          end
        end
        it "メッセージは昇順で整列されている" do
          subject
          users=[other_user3,other_user2,other_user1]
          rooms=JSON.parse(response.body)['data']['rooms']
          rooms.each_with_index do |room,i|
            get(api_v1_user_room_path(cuurent_user.id,room['room']['room_id']))
            res=JSON.parse(response.body)
            expect(res['data']['messages'][-1]['message']).to eq "#{users[i].name}さん、こちらこそよろしくお願いします。"
          end
        end
        context "詳細ページのデータ取得に失敗した場合" do
          it "user_idがnil" do
            subject
            room=JSON.parse(response.body)['data']['rooms'][0]
            begin
              get(api_v1_user_room_path(nil,room['room']['room_id']))
            rescue => e
              expect(e.class).to eq ActionController::UrlGenerationError
            end
          end
          it "user_idに紐づいたユーザが存在しない場合" do
            subject
            room=JSON.parse(response.body)['data']['rooms'][0]
            begin
              get(api_v1_user_room_path(100,room['room']['room_id']))
            rescue => e
              expect(e.class).to eq  ActiveRecord::RecordNotFound
            end
          end
          it "group_idがnil" do
            subject
            rooms=JSON.parse(response.body)['data']['rooms']
            begin
              get(api_v1_user_room_path(cuurent_user.id,nil))
            rescue => e
              expect(e.class).to eq ActionController::UrlGenerationError
            end
          end
          it "group_idに紐づく,チャットルームが存在しない" do
            subject
            rooms=JSON.parse(response.body)['data']['rooms']
            begin
              get(api_v1_user_room_path(cuurent_user.id,100))
            rescue => e
              expect(e.class).to eq  ActiveRecord::RecordNotFound
            end
          end
        end
        context "未読→既読の確認" do
          context "ログインユーザが入室した場合" do
            it "相手の投稿したメッセージステータスが「既読」になる" do
              subject
              rooms=JSON.parse(response.body)['data']['rooms']
              rooms.each_with_index do |room,i|
                get(api_v1_user_room_path(cuurent_user.id,room['room']['room_id']))
                res=JSON.parse(response.body)
                 message=res['data']['messages'].select{|message|message['user_id']!=cuurent_user.id}[0]
                 expect(Message.find( message['id']).read.already_read).to be_truthy
              end
            end
            it "自分が投稿したメッセージは未読のままである" do
              subject
              rooms=JSON.parse(response.body)['data']['rooms']
              rooms.each_with_index do |room,i|
                get(api_v1_user_room_path(cuurent_user.id,room['room']['room_id']))
                res=JSON.parse(response.body)
                 message=res['data']['messages'].select{|message|message['user_id']==cuurent_user.id}[0]
                 expect(Message.find( message['id']).read.already_read).to be_falsey
              end
            end
          end
          context "他のユーザが入室した場合" do
            it "ログインユーザが投稿したメッセージが既読になる" do
              subject
              users=[other_user3,other_user2,other_user1]
              rooms=JSON.parse(response.body)['data']['rooms']
              rooms.each_with_index do |room,i|
                get(api_v1_user_room_path(users[i].id,room['room']['room_id']))
                res=JSON.parse(response.body)
                message=res['data']['messages'].select{|message|message['user_id']==cuurent_user.id}[0]
                expect(Message.find( message['id']).read.already_read).to be_truthy
              end
            end
            it "ログインユーザ以外のユーザが投稿したメッセージが未読になるになる" do
              subject
              users=[other_user3,other_user2,other_user1]
              rooms=JSON.parse(response.body)['data']['rooms']
              rooms.each_with_index do |room,i|
                get(api_v1_user_room_path(users[i].id,room['room']['room_id']))
                res=JSON.parse(response.body)
                message=res['data']['messages'].select{|message|message['user_id']!=cuurent_user.id}[0]
                expect(Message.find( message['id']).read.already_read).to be_falsey
              end
            end
          end
        end
      end
    end
  end
end

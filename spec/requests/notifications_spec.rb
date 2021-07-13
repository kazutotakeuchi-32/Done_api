require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe "GET /notifications" do
    let(:cuurent_user){FactoryBot.create(:test_user1)}
    let(:other_user){FactoryBot.create(:test_user2)}
    let(:draft_learn){FactoryBot.create(:draft_learn,user_id:other_user.id)}
    let(:like){Like.create(user_id:cuurent_user.id,draft_learn_id:draft_learn.id)}
    let(:room){Room.create}
    before do
      cuurent_user.follow(other_user)
      other_user.follow(cuurent_user)
      @message=Message.create(user_id:cuurent_user.id,room_id:room.id,message:"test")
      @notification_dm=Notification.create(sender_id:cuurent_user.id,receiver_id:other_user.id,message_id:@message.id,kind:"DM")
      @notification_like=Notification.create(sender_id:other_user.id,receiver_id:cuurent_user.id,kind:"いいね")
      @notification_follow=Notification.create(sender_id:other_user.id,receiver_id:cuurent_user.id,kind:"フォロー")
    end
    describe "通知機能" do
      describe "一覧" do
        # api_v1_user_notifications_path
        describe "GET /api/v1/users/:user_id/notifications" do
          context "ログインユーザの場合" do
            it "ステータスコード200が返って来る" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              expect(response.status).to eq 200
            end
            it "通知が２件存在する" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              res = JSON.parse(response.body)
              expect(res['data'].size).to eq 2
            end
            it "通知のkindは「いいねとフォロー」である" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              res = JSON.parse(response.body)
              kinds=res['data'].map{|notification|notification['kind']}
              expect(kinds).to include("いいね","フォロー")
            end
            it "受信者はログインユーザーである" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              res = JSON.parse(response.body)
              res['data'].each do |notification|
                expect(notification['receiver']['id']).to eq cuurent_user.id
              end
            end
            it "送信者は他のユーザである" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              res = JSON.parse(response.body)
              res['data'].each do |notification|
                expect(notification['sender']['id']).to eq other_user.id
              end
            end
          end
          context "他のユーザの場合" do
            it "ステータスコード200が返って来る" do
              get(api_v1_user_notifications_path(other_user.id))
              expect(response.status).to eq 200
            end
            it "通知が1件存在する" do
              get(api_v1_user_notifications_path(other_user.id))
              res = JSON.parse(response.body)
              expect(res['data'].size).to eq 1
            end
            it "通知のkindは「DM」である" do
              get(api_v1_user_notifications_path(other_user.id))
              res = JSON.parse(response.body)
              expect(res['data'][0]['kind']).to eq "DM"
            end
            it "受信者は他のユーザである" do
              get(api_v1_user_notifications_path(other_user.id))
              res = JSON.parse(response.body)
              expect(res['data'][0]['receiver']['id']).to eq other_user.id
            end
            it "送信者はログインユーザである" do
              get(api_v1_user_notifications_path(other_user.id))
              res = JSON.parse(response.body)
              expect(res['data'][0]['receiver']['id']).to eq other_user.id
            end
          end
        end
      end
      describe "更新" do
        # api_v1_user_notification_path
        describe "PUT /api/v1/users/:user_id/notification" do
          context "更新に成功" do
            context "ログインユーザの場合" do
              it "ステータスコード200が返って来る"do
                get(api_v1_user_notifications_path(cuurent_user.id))
                res = JSON.parse(response.body)
                put(api_v1_user_notification_path(cuurent_user.id,res['data'][0]['id']))
                expect(response.status).to eq 200
              end
              it "通知が確認済みにになる" do
                get(api_v1_user_notifications_path(cuurent_user.id))
                res = JSON.parse(response.body)
                put(api_v1_user_notification_path(cuurent_user.id,res['data'][0]['id']))
                expect(Notification.find(res['data'][0]['id']).checked).to  be_truthy
              end
              it "通知を確認済み後、もう一度リクエストを送ると、通知数が１件になる" do
                get(api_v1_user_notifications_path(cuurent_user.id))
                res = JSON.parse(response.body)
                put(api_v1_user_notification_path(cuurent_user.id,res['data'][0]['id']))
                get(api_v1_user_notifications_path(cuurent_user.id))
                res = JSON.parse(response.body)
                expect(res['data'].size).to eq 1

              end
            end
            context "他のユーザの場合" do
              it "ステータスコード200が返って来る"do
                get(api_v1_user_notifications_path(other_user.id))
                res = JSON.parse(response.body)
                put(api_v1_user_notification_path(other_user.id,res['data'][0]['id']))
                expect(response.status).to eq 200
                expect(res['data'].size).to eq 1
              end
              it "通知が確認済みにになる" do
                get(api_v1_user_notifications_path(other_user.id))
                res = JSON.parse(response.body)
                put(api_v1_user_notification_path(other_user.id,res['data'][0]['id']))
                expect(Notification.find(res['data'][0]['id']).checked).to  be_truthy
              end
              it "通知を確認済み後、もう一度リクエストを送ると、通知数が0件になる" do
                get(api_v1_user_notifications_path(other_user.id))
                res = JSON.parse(response.body)
                put(api_v1_user_notification_path(other_user.id,res['data'][0]['id']))
                get(api_v1_user_notifications_path(other_user.id))
                res = JSON.parse(response.body)
                expect(res['data'].size).to eq 0
              end
            end
          end
          context "更新に失敗" do
            it "user_idがnil" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              res = JSON.parse(response.body)
              begin
                put(api_v1_user_notification_path(nil,res['data'][0]['id']))
              rescue => e
                expect(e.class).to eq ActionController::UrlGenerationError
              end
            end
            it "idがnil" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              res = JSON.parse(response.body)
              begin
                put(api_v1_user_notification_path(cuurent_user.id,nil))
              rescue => e
                p e.class
                expect(e.class).to eq ActionController::UrlGenerationError
              end
            end
            it "idに紐づく通知が存在しない" do
              get(api_v1_user_notifications_path(cuurent_user.id))
              res = JSON.parse(response.body)
              begin
                put(api_v1_user_notification_path(cuurent_user.id,100))
              rescue => e
                expect(e.class).to eq ActiveRecord::RecordNotFound
              end
            end
          end
        end
      end
    end
  end
end

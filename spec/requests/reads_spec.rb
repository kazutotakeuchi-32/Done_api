require 'rails_helper'

RSpec.describe "Reads", type: :request do
  let(:cuurent_user){FactoryBot.create(:test_user1)}
  let(:room){Room.create}
  let(:message){Message.create(user_id:cuurent_user.id,room_id:room.id,message:"test")}
  let(:read){Read.create(user_id:cuurent_user.id,message_id:message.id,room_id:room.id)}

  describe "既読機能" do
    context "更新に成功" do
      it "ステータスコード200が返って来る" do
        put(api_v1_user_room_read_path(cuurent_user.id,room.id,read.id),params:{room:{already_read:true}})
        expect(response.status).to eq 200
      end
      it "already_readがtrueになっている" do
        put(api_v1_user_room_read_path(cuurent_user.id,room.id,read.id),params:{room:{already_read:true}})
        new_read= Read.find(read.id)
        expect(new_read.already_read).to be_truthy
      end
    end
    context "更新に失敗" do
      it "user_idがnil" do
        begin
          put(api_v1_user_room_read_path(nil,room.id,read.id),params:{room:{already_read:true}})
        rescue => e
          expect(e.class).to eq ActionController::UrlGenerationError
        end
      end
      it "user_idに紐づくユーザが存在しない" do
        begin
          put(api_v1_user_room_read_path(100,room.id,read.id),params:{room:{already_read:true}})
        rescue => e
         expect(e.class).to eq ActiveRecord::RecordNotFound
        end
      end
      it "room_idがnil" do
        begin
          put(api_v1_user_room_read_path(cuurent_user.id,nil,read.id),params:{room:{already_read:true}})
        rescue => e
         expect(e.class).to eq ActionController::UrlGenerationError
        end
      end
      it "room_idに紐づくチャットルームが存在しない" do
        begin
          put(api_v1_user_room_read_path(cuurent_user.id,100,read.id),params:{room:{already_read:true}})
        rescue => e
          expect(e.class).to eq ActiveRecord::RecordNotFound
        end
      end
      it "idがnil" do
        begin
          put(api_v1_user_room_read_path(cuurent_user.id,nil,read.id),params:{room:{already_read:true}})
        rescue => e
         expect(e.class).to eq ActionController::UrlGenerationError
        end
      end
      it "idに紐づくreadが存在しない" do
        begin
          put(api_v1_user_room_read_path(cuurent_user.id,100,read.id),params:{room:{already_read:true}})
        rescue => e
          expect(e.class).to eq ActiveRecord::RecordNotFound
        end
      end
      it "paramsが空" do
        begin
          put(api_v1_user_room_read_path(cuurent_user.id,100,read.id),params:{})
        rescue => e
          expect(e.class).to eq ActionController::ParameterMissing
        end
      end
    end
  end
end

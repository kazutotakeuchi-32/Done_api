require 'rails_helper'
RSpec.describe "Entries", type: :request do
  let(:cuurent_user){FactoryBot.create(:test_user1)}
  let(:other_user){FactoryBot.create(:test_user2)}
  describe "チャットルーム作成" do
    describe "POST /api/v1/entries?user_id=&other_user=" do
      subject{ post(api_v1_entries_path,params:{user_id:cuurent_user.id,other_user:other_user.id})}
      context "相互フォローではなかった場合" do
        it "ステータスコードが401が返ってくる" do
          subject
          expect(response.status).to eq 401
        end
        it "「相互フォローしていないのでチャットルームを作成する事ができません」というメッセージを含む" do
          subject
          res = JSON.parse(response.body)
          expect(res['data']['message']).to eq "相互フォローしていないのでチャットルームを作成する事ができません"
        end
      end
      context "相互フォローである場合" do
        before do
          cuurent_user.follow(other_user)
          other_user.follow(cuurent_user)
        end
        context "チャットルームが存在しない場合" do
          it "ステータスコードが200が返ってくる" do
            subject
            expect(response.status).to eq 200
          end
          it "チャットルーム数が増える" do
            expect{subject}.to change(Room, :count).from(0).to(1)
          end
        end
        context "チャットルームが存在する場合" do
          before do
            subject
          end
          it "ステータスコードが200が返ってくる" do
            subject
            expect(response.status).to eq 200
          end
          it "チャットルーム数が変わらない" do
            expect{subject}.to change(Room, :count).by(0)
          end
          it "「チャットルームは既に存在します。」というメッセージを含む" do
            post(api_v1_entries_path,params:{user_id:cuurent_user.id,other_user:other_user.id})
            res = JSON.parse(response.body)
            expect(res['data']['message']).to eq "チャットルームは既に存在します。"
          end
        end
      end
    end
  end
end

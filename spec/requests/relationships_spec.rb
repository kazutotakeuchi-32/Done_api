require 'rails_helper'
RSpec.describe "Relationships", type: :request do
  describe "フォロー機能" do
    let(:current_user){FactoryBot.create(:test_user1)}
    let(:other_user){FactoryBot.create(:test_user2)}
    before do
      @params=auth_post current_user, api_v1_user_session_path, params:{email:current_user.email,password:"000000"}
    end
    describe "フォロー"do
      describe "post /api/v1/relationships" do
        context "フォローしていないユーザをフォローした場合" do
          it "ステータスコード200が返ってくる" do
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
          it "フォローしたユーザの'フォロ-数'が増えたレスポンス値が返ってくる" do
            before_followings_size=current_user.followings.ids.size
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(before_followings_size < res['data']['followings'].size).to be_truthy
          end
          it "フォローされたユーザのidが存在する" do
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['followings']).to include(other_user.id)
          end
        end
        context "フォロー済みのユーザをフォローした場合" do
          before do
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:@params[:headers])
          end
          it "「既にフォローしています。」というメッセージが返ってくる" do
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['message']).to include("既にフォローしています。")
          end
          it "フォローしたユーザの'フォロ-数'が変わらない" do
            before_followings_size=current_user.followings.ids.size
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(before_followings_size).to eq res['data']['followings'].size
          end
        end
        context "存在しないユーザのIDをリクエストした場合" do
          it "NoMethodError" do
            begin
              post(api_v1_relationships_path,params:{follow_id:10},headers:@params[:headers])
            rescue => e
              expect(e.class).to eq NoMethodError
            end
          end
        end
        context "ログインしていない場合" do
          it "フォローできない" do
            before_followings_size=current_user.followings.ids.size
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:{})
            res = JSON.parse(response.body)
            expect(res['errors']).to include("ログインもしくはアカウント登録してください。")
          end
        end
      end
      context "通知" do
      end
    end
    describe "アンフォロー"do
      describe "delete /api/v1/relationships" do
        context "フォローしていたユーザをアンフォローした場合" do
          before do
            post(api_v1_relationships_path,params:{follow_id:other_user.id},headers:@params[:headers])
          end
          it "ステータスコード200が返ってくる" do
            delete(api_v1_relationship_path(other_user.id),headers:@params[:headers])
            expect(response.status).to eq 200
          end
          it "フォローしたユーザの'フォロ-数'が減ったレスポンス値が返ってくる" do
            before_followings_size=current_user.followings.ids.size
            delete(api_v1_relationship_path(other_user.id),headers:@params[:headers])
            res=JSON.parse(response.body)
            expect(before_followings_size > res['data']['followings'].size).to be_truthy
          end
          context "ログインしていない場合" do
            it "アンフォローできない" do
              before_followings_size=current_user.followings.ids.size
              delete(api_v1_relationship_path(other_user.id),headers:{})
              res = JSON.parse(response.body)
              expect(res['errors']).to include("ログインもしくはアカウント登録してください。")
            end
          end
        end
      end
      context "フォローしていないユーザをアンフォローした場合" do
        it "ステータスコード200が返ってくる" do
          delete(api_v1_relationship_path(other_user.id),headers:@params[:headers])
          expect(response.status).to eq 200
        end
        it "フォローしたユーザの'フォロ-数'が変わらないレスポンス値が返ってくる" do
          before_followings_size=current_user.followings.ids.size
          delete(api_v1_relationship_path(other_user.id),headers:@params[:headers])
          res=JSON.parse(response.body)
          expect(before_followings_size == res['data']['followings'].size).to be_truthy
        end
        it "「フォローしていません」とメッセージが返ってくる" do
          delete(api_v1_relationship_path(other_user.id),headers:@params[:headers])
          res=JSON.parse(response.body)
          expect(res['data']["message"]).to include "フォローしていません"
        end
      end
      context "存在しないユーザのIDをリクエストした場合" do
        it "ActiveRecord::RecordNotFound" do
          begin
            delete(api_v1_relationship_path(10),headers:@params[:headers])
          rescue => e
            expect(e.class).to eq ActiveRecord::RecordNotFound
          end
        end
      end
      context "通知削除" do
      end
    end
  end
end

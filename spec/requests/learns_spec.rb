require 'rails_helper'

RSpec.describe "Learns", type: :request do
  let(:user){FactoryBot.create(:other)}
  let(:draft_learn){FactoryBot.create(:draft_learn,user_id:user.id)}
  let(:learn){FactoryBot.build(:learn,user_id:user.id,draft_learn_id:draft_learn.id)}
  describe "学習完了投稿機能" do
    before do
      @params=auth_post user, api_v1_user_session_path,
      params:{
        email:user.email,
        password:"000000"
      }
      @learn_params={
        title:learn.title,
        content:learn.content,
        time:learn.time,
        subject:learn.subject,
        user_id:learn.user_id,
      }
    end
    describe "Post /api/v1/learns #create" do
        context "投稿に成功する" do
          describe "ログインをしている" do
            it "ログインに成功している" do
              expect(@params[:status]).to eq 200
            end
            it "全ての項目が入力されている。" do
              post(api_v1_learns_path ,params:{learn:@learn_params,draft_learn_id:draft_learn.id},headers:@params[:headers])
              res = JSON.parse(response.body)
              expect(res['data']['message']).to include "OK"
            end
            it "ステータスコード200が返ってくる" do
              post(api_v1_learns_path ,params:{learn:@learn_params,draft_learn_id:draft_learn.id},headers:@params[:headers])
              expect(response.status).to eq 200
            end
            context "ログインしてから14日以内" do
              around do |e|
                travel_to('2021-2-29 10:00'.to_time){ e.run }
              end
              it "14日以内であれば投稿できる" do
                travel 13.day
                post(api_v1_learns_path ,params:{learn:@learn_params,draft_learn_id:draft_learn.id},headers:@params[:headers])
                expect(response.status).to eq 200
              end
            end
          end
        end
        context "投稿に失敗する" do
          describe "ログインをしていない" do
            it "ログインをしていないユーザは投稿できない" do
              post(api_v1_learns_path ,params:{learn:@learn_params,draft_learn_id:draft_learn.id},headers:{})
              expect(response.status).to eq 401
              res = JSON.parse(response.body)
              expect(res['errors']).to include("ログインもしくはアカウント登録してください。")
            end
          end
          describe "ログインをしている" do
            it "タスク名が入力されていない" do
              post(api_v1_learns_path ,params:{learn:@learn_params.merge(title:nil),draft_learn_id:draft_learn.id},headers:@params[:headers])
              expect( response.status).to eq(401)
              res = JSON.parse(response.body)
              expect(res['errors']).to include("Titleを入力してください")
            end
            it "学習時間が入力されていない" do
              post(api_v1_learns_path ,params:{learn:@learn_params.merge(time:nil),draft_learn_id:draft_learn.id},headers:@params[:headers])
              expect( response.status).to eq(401)
              res = JSON.parse(response.body)
              expect(res['errors']).to include("Timeを入力してください")
            end
            it "学習内容が入力されていない" do
              post(api_v1_learns_path ,params:{learn:@learn_params.merge(content:nil),draft_learn_id:draft_learn.id},headers:@params[:headers])
              expect( response.status).to eq(401)
              res = JSON.parse(response.body)
              expect(res['errors']).to include("Contentを入力してください")
            end
            it "カテゴリーが入力されていない" do
              post(api_v1_learns_path ,params:{learn:@learn_params.merge(subject:nil),draft_learn_id:draft_learn.id},headers:@params[:headers])
              expect( response.status).to eq(401)
              res = JSON.parse(response.body)
              expect(res['errors']).to include("Subjectを入力してください")
            end
            it "学習計画が投稿されていない" do
              post(api_v1_learns_path ,params:{learn:@learn_params,draft_learn_id:nil},headers:@params[:headers])
              expect( response.status).to eq(401)
              res = JSON.parse(response.body)
              expect(res['errors']).to include("Draft learnを入力してください")
            end
            context "ログインしてから14日が過ぎた場合" do
              around do |e|
                travel_to('2021-2-29 10:00'.to_time){ e.run }
              end
              it "14日を過ぎると投稿できない" do
                travel 14.day
                post(api_v1_learns_path ,params:{learn:@learn_params},headers:@params[:headers])
                expect(response.status).to eq 401
                res = JSON.parse(response.body)
                expect(res['errors']).to include("ログインもしくはアカウント登録してください。")
              end
            end
          end
        end
    end
  end
end

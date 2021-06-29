require 'rails_helper'
RSpec.describe "DraftLearns", type: :request do
  let(:user) { FactoryBot.create(:other) }
  let(:draft_learn){FactoryBot.build(:draft_learn,user_id:user.id)}
  before do
    @params=auth_post user, api_v1_user_session_path,
    params:{
      email:user.email,
      password:"000000"
    }
    @draft_learn_params={
      title:draft_learn.title,
      content:draft_learn.content,
      time:draft_learn.time,
      subject:draft_learn.subject,
      user_id:user.id
    }
  end
  describe "学習計画投稿機能" do
    describe "Post /api/v1/draft_learns #create" do
      context "投稿に成功する" do
        describe "ログインしている" do
          it "ログインに成功している" do
            expect(@params[:status]).to eq 200
          end
          it "全ての項目が入力されている。" do
            post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params},headers:@params[:headers])
              res = JSON.parse(response.body)
            expect(res['data']['message']).to include "OK"
          end
          it "ステータスコード200が返ってくる" do
            post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params},headers:@params[:headers])
            expect(response.status).to eq 200
          end
          context "ログインしてから14日以内" do
            around do |e|
              travel_to('2021-2-29 10:00'.to_time){ e.run }
            end
            it "14日以内であれば投稿できる" do
              travel 13.day
              post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params},headers:@params[:headers])
              expect(response.status).to eq 200
            end
          end
        end
      end
      context "投稿に失敗する" do
        describe "ログインしていない" do
          it "ログインしていないユーザは投稿できない" do
            post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params},headers:{})
            expect( response.status).to eq(401)
            res = JSON.parse(response.body)
            expect(res['errors']).to include("ログインもしくはアカウント登録してください。")
          end
        end
        describe "ログインしている" do
          it "タスク名が入力されていない" do
            post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params.merge(title:nil)},headers:@params[:headers])
            expect( response.status).to eq(401)
            res = JSON.parse(response.body)
            expect(res['errors']).to include("Titleを入力してください")
          end
          it "学習時間が入力されていない" do
            post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params.merge(time:nil)},headers:@params[:headers])
            expect( response.status).to eq(401)
            res = JSON.parse(response.body)
            expect(res['errors']).to include("Timeを入力してください")
          end
          it "学習内容が入力されていない" do
            post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params.merge(content:nil)},headers:@params[:headers])
            expect( response.status).to eq(401)
            res = JSON.parse(response.body)
            expect(res['errors']).to include("Contentを入力してください")
          end
          it "カテゴリーが入力されていない" do
            post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params.merge(subject:nil)},headers:@params[:headers])
            expect( response.status).to eq(401)
            res = JSON.parse(response.body)
            expect(res['errors']).to include("Subjectを入力してください")
          end
          context "ログインしてから14日が過ぎた場合" do
            around do |e|
              travel_to('2021-2-29 10:00'.to_time){ e.run }
            end
            it "14日を過ぎると投稿できない" do
              travel 14.day
              post(api_v1_draft_learns_path ,params:{draft_learn:@draft_learn_params},headers:@params[:headers])
              expect(response.status).to eq 401
              res = JSON.parse(response.body)
              expect(res['errors']).to include("ログインもしくはアカウント登録してください。")
            end
          end
        end
      end
    end
  end
  describe "今日のタスク" do
    describe "GET /api/v1/draft_learns/todays_task #todays_task" do
      let(:other_user){FactoryBot.create(:test_user1)}
      before do
        FactoryBot.create(:draft_learn,user_id:user.id,created_at:Time.now)
        FactoryBot.create(:draft_learn,user_id:other_user.id)
      end
        describe "タスクを取得できる" do
          it "当日のタスクが存在する" do
            get(todays_task_api_v1_draft_learns_path,params:{id:user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['nextTasks']['data'].size).to eq 1
          end
          it "ステータスコード200が返ってくる" do
            get(todays_task_api_v1_draft_learns_path,params:{id:user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
        describe "他のユーザのタスクも取得ができる" do
          it "当日のタスクが存在する" do
            get(todays_task_api_v1_draft_learns_path,params:{id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['nextTasks']['data'].size).to eq 1
          end
          it "ステータスコード200が返ってくる" do
            get(todays_task_api_v1_draft_learns_path,params:{id:user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
        describe "タスクを取得できない" do
          it "そもそもタスクが存在しない" do
            travel 2.day
            get(todays_task_api_v1_draft_learns_path,params:{id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['nextTasks']['data']).to  be_empty
          end
        end
    end
  end
end

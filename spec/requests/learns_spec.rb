require 'rails_helper'
RSpec.describe "Learns", type: :request do
  let(:user){FactoryBot.create(:other)}
  let(:draft_learn){FactoryBot.create(:draft_learn,user_id:user.id)}
  let(:learn){FactoryBot.build(:learn,user_id:user.id,draft_learn_id:draft_learn.id)}
  let(:other_user){FactoryBot.create(:test_user1)}
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
  describe "学習完了投稿機能" do
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
  describe "今日のタスク" do
    describe "GET /api/v1/learns/todays_task #todays_task" do
      before do
        FactoryBot.create(:learn,draft_learn_id:draft_learn.id,user_id:user.id,created_at:Time.now)
        FactoryBot.create(:learn,draft_learn_id:draft_learn.id,user_id:other_user.id)
      end
        describe "タスクを取得できる" do
          it "当日のタスクが存在する" do
            get(todays_task_api_v1_learns_path,params:{id:user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['nextTasks']['data'].size).to eq 1
          end
          it "ステータスコード200が返ってくる" do
            get(todays_task_api_v1_learns_path,params:{id:user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
        describe "他のユーザのタスクも取得ができる" do
          it "当日のタスクが存在する" do
            get(todays_task_api_v1_learns_path,params:{id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['nextTasks']['data'].size).to eq 1
          end
          it "ステータスコード200が返ってくる" do
            get(todays_task_api_v1_learns_path,params:{id:user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
        describe "タスクを取得できない" do
          it "そもそもタスクが存在しない" do
            travel 2.day
            get(todays_task_api_v1_learns_path,params:{id:other_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['nextTasks']['data']).to  be_empty
          end
        end
    end
  end
  describe "過去のタスク" do
    describe "GET /api/v1/learns/past_tasks?id=&cuurent_page=&rows=" do
      before "" do
        100.times do |n|
          FactoryBot.create(:learn,draft_learn_id:draft_learn.id,user_id:user.id,created_at:Time.now)
          FactoryBot.create(:learn,draft_learn_id:draft_learn.id,user_id:other_user.id)
        end
      end
      describe "データが降順に整列されている" do
        it "１ページ目の最初のタスクが最後にDBに登録されていれば、降順に整列されている" do
          travel 1.day
          get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:1,rows:10},headers:@params[:headers])
          res=JSON.parse(response.body)
          last_learn=Learn.where(user_id:user.id)[-1]
          expect(res['data']['previousTasks']['data'][0]['id']).to eq  last_learn.id
        end
      end
      context "最大タスク表示数10の場合" do
        describe "1ページ目" do
          subject{ get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:1,rows:10},headers:@params[:headers])}
          it "10個のタスクを取得する" do
            travel 1.day
            subject
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 10
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            subject
            expect(response.status).to eq 200
          end
        end
        describe "5ページ目" do
          it "10個のタスクを取得する" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:5,rows:10},headers:@params[:headers])
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 10
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:5,rows:10},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
        describe "10ページ目" do
          it "10個のタスクを取得する" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:10,rows:10},headers:@params[:headers])
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 10
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:10,rows:10},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
      end
      context "最大タスク表示数20の場合" do
        subject{ get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:1,rows:20},headers:@params[:headers])}
        describe "1ページ目" do
          it "20個のタスクを取得する" do
            travel 1.day
            subject
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 20
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            subject
            expect(response.status).to eq 200
          end
        end
        describe "2ページ目" do
          it "20個のタスクを取得する" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:2,rows:20},headers:@params[:headers])
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 20
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:2,rows:20},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
        describe "5ページ目" do
          it "20個のタスクを取得する" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:2,rows:20},headers:@params[:headers])
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 20
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:2,rows:20},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
      end
      context "最大タスク表示数30の場合" do
        subject{ get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:1,rows:30},headers:@params[:headers])}
        describe "1ページ目" do
          it "30個のタスクを取得する" do
            travel 1.day
            subject
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 30
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            subject
            expect(response.status).to eq 200
          end
        end
        describe "3ページ目" do
          it "30個のタスクを取得する" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:3,rows:30},headers:@params[:headers])
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 30
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:3,rows:30},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
        describe "4ページ目" do
          it "10個のタスクを取得する" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:4,rows:30},headers:@params[:headers])
            res=JSON.parse(response.body)
            expect(res['data']['previousTasks']['data'].size).to eq 10
          end
          it "ステータスコードが200が返ってくる" do
            travel 1.day
            get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:4,rows:30},headers:@params[:headers])
            expect(response.status).to eq 200
          end
        end
      end
      describe "存在しないページが指定された" do
        it "タスクが存在しない(nil)" do
          travel 1.day
          get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:5,rows:30},headers:@params[:headers])
          res=JSON.parse(response.body)
          expect(res['data']['previousTasks']['data']).to be_nil
        end
      end
      describe "存在しないユーザが指定された" do
        it "ステータスコード401が返ってくる"do
        travel 1.day
          get(past_tasks_api_v1_learns_path,params:{id:100,cuurent_page:5,rows:30},headers:@params[:headers])
          expect(response.status).to eq 401
        end
        it "エラーメッセージが返ってくる" do
          get(past_tasks_api_v1_learns_path,params:{id:100,cuurent_page:5,rows:30},headers:@params[:headers])
          res=JSON.parse(response.body)
          expect(res['data']['errors']).to include("ユーザが存在しません。")
        end
      end
      describe "当日のタスクは取得しない" do
        it "データが存在しない" do
          get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:5,rows:30},headers:@params[:headers])
          res=JSON.parse(response.body)
          expect(res['data']['previousTasks']['data']).to be_nil
        end
        it "ステータスコード200が返ってくる" do
          get(past_tasks_api_v1_learns_path,params:{id:user.id,cuurent_page:5,rows:30},headers:@params[:headers])
          res=JSON.parse(response.body)
          expect(res['data']['previousTasks']['data']).to be_nil
        end
      end
    end
  end
end

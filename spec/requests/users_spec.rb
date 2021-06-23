require 'rails_helper'
RSpec.describe "Users", type: :request do
  describe "マイページ " do
    let(:user){FactoryBot.create(:other)}
    before do
      @params=auth_post user, api_v1_user_session_path,
      params:{
        email:user.email,
        password:"000000"
      }
    end
    describe "GET /api/v1/users/:id #show" do
      context "マイページにアクセスできる(デフォルト)" do
        context "分析機能" do
          describe "取得したい学習状況の日付・集計モデルを指定する" do
            describe "GET /api/v1/users/:id?type=&year=&month=&day= #show" do
              it "2020年4月１日から一年のデータを集計" do
                get(api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"4",day:"1"})
                res = JSON.parse(response.body)
                previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
                expect(previous_tasks.size).to eq 12
                expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("3月")
              end
              it "2020年7月１日から半年のデータを集計" do
                get(api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"7",day:"1"})
                res = JSON.parse(response.body)
                previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
                expect(previous_tasks.size).to eq 6
                expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("12月")
              end
              it "2021年1月1日から3ヶ月のデータを集計" do
                get(api_v1_user_path(user.id),params:{type:"3months",year:"2021",month:"1",day:"1"})
                res = JSON.parse(response.body)
                 previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
                expect(previous_tasks.size).to eq 3
                expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("3月")
              end
              it "2021年5月1日から1ヶ月のデータを集計" do
                get(api_v1_user_path(user.id),params:{type:"month",year:"2021",month:"5",day:"1"})
                res = JSON.parse(response.body)
                 previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
                expect(previous_tasks.size).to eq 31
                expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("5月31日")
              end
              it "2021年5月1日から1週間のデータを集計" do
                get(api_v1_user_path(user.id),params:{type:"week",year:"2021",month:"5",day:"1"})
                res = JSON.parse(response.body)
                 previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
                expect(previous_tasks.size).to eq 7
                expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("5月7日")
              end
              it "2021年6月1日のデータを集計" do
                get(api_v1_user_path(user.id),params:{type:"day",year:"2021",month:"6",day:"1"})
                res = JSON.parse(response.body)
                 previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
                expect(previous_tasks.size).to eq 1
                expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("6月1日")
              end
            end
         end
        end
        it "ステータスコード200が返ってくる" do
          get(api_v1_user_path(user.id))
          expect(response.status).to eq 200
        end
        it "ユーザ情報がレスポンスとして返ってくる" do
          get(api_v1_user_path(user.id))
          res = JSON.parse(response.body)
          res_user = User.find(res['data']['user']['id'])
          expect(res_user.class).to eq User
        end
        it "当日の学習計画の情報がレスポンスとして返ってくる" do
          get(api_v1_user_path(user.id))
          res = JSON.parse(response.body)
          now_time=Time.now
          expect(res['data']["draftLearns"]['nextTasks']['title']).to include("#{now_time.month}月#{now_time.day}日")
        end
        it "7日間の学習計画の情報がレスポンスとして返ってくる" do
          get(api_v1_user_path(user.id))
          res = JSON.parse(response.body)
          previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
          expect(previous_tasks.size).to eq 7
        end
        it "当日の学習計画の情報がレスポンスとして返ってくる" do
          get(api_v1_user_path(user.id))
          res = JSON.parse(response.body)
          now_time=Time.now
          expect(res['data']["learns"]['nextTasks']['title']).to include("#{now_time.month}月#{now_time.day}日")
        end
        it "7日間の学習計画の情報がレスポンスとして返ってくる" do
          get(api_v1_user_path(user.id))
          res = JSON.parse(response.body)
          expect(res['data']["learns"]['previousTasks']['data'].size).to eq 7
        end
      end
      context "マイページにアクセスできない" do
        it "存在しないユーザ" do
          get(api_v1_user_path(10))
          res=JSON.parse(response.body)
          expect(res['errors']).to include "ユーザが存在しません"
        end
        it "ステータスコード401が返ってくる" do
          get(api_v1_user_path(10))
          expect(response.status).to eq 401
        end
      end
    end
  end
end

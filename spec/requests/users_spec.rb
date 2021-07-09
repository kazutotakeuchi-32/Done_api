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
    # describe "GET /api/v1/users/:id #show" do
    #   context "マイページにアクセスできる(デフォルト)" do
        # context "分析機能" do
        #   before do
        #     365.times do |n|
        #       draft_learn=DraftLearn.new({id: nil, title: "test#{n}", content: "content#{n}", subject: "test", time: 1, created_at: nil, updated_at: nil,user_id:user.id})
        #       draft_learn.save!
        #       learn = Learn.new({id: nil, title: "test#{n}", content: "content#{n}", subject: "", time: 1, created_at: nil, updated_at: nil,draft_learn_id:draft_learn.id,user_id:user.id})
        #       subject=rand(4)
        #       case subject
        #         when 0
        #           draft_learn.subject="プログラミング"
        #           learn.subject="プログラミング"
        #         when 1
        #           draft_learn.subject="英語"
        #           learn.subject="英語"
        #         when 2
        #           draft_learn.subject="資格"
        #           learn.subject="資格"
        #         when 3
        #           draft_learn.subject="その他"
        #           learn.subject="その他"
        #       end
        #       draft_learn.created_at=Time.new("2020","1","1").since(n.day)
        #       draft_learn.save!
        #       learn.created_at=Time.new("2020","1","1").since(n.day)
        #       learn.save!
        #     end
        #   end
        #   describe "円グラフ用のエンドポイント" do
        #     describe "GET /api/v1/users/:id/pie_graph #pie_graph" do
        #       context "1年で集計する場合" do
        #         describe "2020/1/1~2020/12/31" do
        #           it "ステータスコード200が返ってくる" do
        #             get(pie_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #             res=JSON.parse(response.body)
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "365個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 365
        #             end
        #             it "グラフタイトル「2020年1月1日~12月31日の学習予定」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~12月31日の学習予定")
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "365個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 365
        #             end
        #             it "グラフタイトル「2020年1月1日~12月31日の学習状況」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['learns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~12月31日の学習状況")
        #             end
        #           end
        #         end
        #       end
        #       context "6ヶ月で集計する場合" do
        #         describe "2020/1/1~2020/6/30" do
        #           it "ステータスコード200が返ってくる" do
        #             get(pie_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #             res=JSON.parse(response.body)
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "182個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 182
        #             end
        #             it "グラフタイトル「2020年1月1日~2020年6月30日の学習予定」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~6月30日の学習予定")
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "182個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 182
        #             end
        #             it "グラフタイトル「2020年1月1日~2020年6月30日の学習状況」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['learns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~6月30日の学習状況")
        #             end
        #           end
        #         end
        #       end
        #       context "3ヶ月で集計する場合" do
        #         describe "2020/1/1~2020/3/31" do
        #           it "ステータスコード200が返ってくる" do
        #             get(pie_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #             res=JSON.parse(response.body)
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "91個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 91
        #             end
        #             it "グラフタイトル「2020年1月1日~2020年3月31日の学習予定」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~3月31日の学習予定")
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "91個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 91
        #             end
        #             it "グラフタイトル「2020年1月1日~3月31日の学習状況」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['learns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~3月31日の学習状況")
        #             end
        #           end
        #         end
        #       end
        #       context "1ヶ月で集計する場合" do
        #         describe "2020/1/1~2020/1/31" do
        #           it "ステータスコード200が返ってくる" do
        #             get(pie_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #             res=JSON.parse(response.body)
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "31個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 31
        #             end
        #             it "グラフタイトル「2020年1月1日~1月31日の学習予定」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~1月31日の学習予定")
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "31個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 31
        #             end
        #             it "グラフタイトル「2020年1月1日~1月31日の学習状況」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['learns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~1月31日の学習状況")
        #             end
        #           end
        #         end
        #       end
        #       context "1週間で集計する場合" do
        #         describe "2020/1/1~1/7" do
        #           it "ステータスコード200が返ってくる" do
        #             get(pie_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #             res=JSON.parse(response.body)
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "7個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 7
        #             end
        #             it "グラフタイトル「2020年1月1日~1月7日の学習予定」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~1月7日の学習予定")
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "7個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 7
        #             end
        #             it "グラフタイトル「2020年1月1日~1月7日の学習状況」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['learns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~1月7日の学習状況")
        #             end
        #           end
        #         end
        #       end
        #       context "1日で集計する場合" do
        #         describe "2020/1/1 00:00:00 23:59:59" do
        #           it "ステータスコード200が返ってくる" do
        #             get(pie_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #             res=JSON.parse(response.body)
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "7個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 1
        #             end
        #             it "グラフタイトル「2020年1月1日の学習予定」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日の学習予定")
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "1個のデータが存在する" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 1
        #             end
        #             it "グラフタイトル「2020年1月1日の学習状況」" do
        #               get(pie_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['learns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日の学習状況")
        #             end
        #           end
        #          end
        #       end
        #     end
        #   end
        #   describe "棒グラフ用のエンドポイント" do
        #     describe "GET /api/v1/users/:id/bar_graph #bar_graph" do
        #       context "1年で集計する場合" do
        #         describe "2020/1/1~2020/12/31" do
        #           it "ステータスコード200が返ってくる" do
        #             get(bar_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "12個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 12
        #             end
        #             it "グラフタイトル「2020年1月1日~12月31日の学習状況」" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~12月31日の学習状況")
        #             end
        #             it "総学習計画時間は365時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               total_time=data.sum{ |d| d['data'].to_i}
        #               expect(total_time).to eq(365)
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "12個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 12
        #             end
        #             it "総学習時間は365時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               total_time=data.sum{ |d| d['data'].to_i}
        #               expect(total_time).to eq(365)
        #             end
        #           end
        #         end
        #       end
        #       context "6ヶ月で集計する場合" do
        #         describe "2020/1/1~2020/6/30" do
        #           it "ステータスコード200が返ってくる" do
        #             get(bar_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "6個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 6
        #             end
        #             it "グラフタイトル「2020年1月1日~6月30日の学習状況」" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~6月30日の学習状況")
        #             end
        #             it "総学習計画時間は182時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               total_time=data.sum{|d| d['data'].to_i}
        #               expect(total_time).to eq(182)
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "6個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 6
        #             end
        #             it "総学習時間は182時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               total_time=data.sum{ |d| d['data'].to_i}
        #               expect(total_time).to eq(182)
        #             end
        #           end
        #         end
        #       end
        #       context "3ヶ月で集計する場合" do
        #         describe "2020/1/1~2020/3/31" do
        #           it "ステータスコード200が返ってくる" do
        #             get(bar_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "3個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 3
        #             end
        #             it "グラフタイトル「2020年1月1日~3月31日の学習状況」" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~3月31日の学習状況")
        #             end
        #             it "総学習計画時間は91時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(91)
        #             end

        #           end
        #           describe "学習の振り返り" do
        #             it "3個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 3
        #             end
        #             it "総学習時間は91時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"3months",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(91)
        #             end
        #           end
        #         end
        #       end
        #       context "1ヶ月で集計する場合" do
        #         describe "2020/1/1~2020/1/31" do
        #           it "ステータスコード200が返ってくる" do
        #             get(bar_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "31個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 31
        #             end
        #             it "グラフタイトル「2020年1月1日~1月31日の学習状況」" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~1月31日の学習状況")
        #             end
        #             it "総学習計画時間は31時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(31)
        #             end

        #           end
        #           describe "学習の振り返り" do
        #             it "31個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 31
        #             end
        #             it "総学習時間は31時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"month",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(31)
        #             end
        #           end
        #         end
        #       end
        #       context "1週間で集計する場合" do
        #         describe "2020/1/1~1/7" do
        #           it "ステータスコード200が返ってくる" do
        #             get(bar_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "7個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 7
        #             end
        #             it "グラフタイトル「2020年1月1日~1月7日の学習状況」" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日~1月7日の学習状況")
        #             end
        #             it "総学習計画時間は7時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(7)
        #             end
        #           end
        #           describe "学習の振り返り" do
        #             it "7個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 7
        #             end
        #             it "総学習時間は7時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"week",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(7)
        #             end
        #           end
        #         end
        #       end
        #       context "1日で集計する場合" do
        #         describe "2020/1/1 00:00:00~23:59:59" do
        #           it "ステータスコード200が返ってくる" do
        #             get(bar_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #             expect(response.status).to eq 200
        #           end
        #           describe "学習計画" do
        #             it "1個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               expect(data.size).to eq 1
        #             end
        #             it "グラフタイトル「2020年1月1日の学習状況」" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               title=res['data']['draftLearns']['search_tasks']['title']
        #               expect(title).to eq("2020年1月1日の学習状況")
        #             end
        #             it "総学習計画時間は1時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['draftLearns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(1)
        #             end

        #           end
        #           describe "学習の振り返り" do
        #             it "1個のデータが存在する" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               expect(data.size).to eq 1
        #             end
        #             it "総学習時間は1時間" do
        #               get(bar_graph_api_v1_user_path(user.id),params:{type:"day",year:"2020",month:"1",day:"1"})
        #               res=JSON.parse(response.body)
        #               data=res['data']['learns']['search_tasks']['data']
        #               total_time=data.sum { |d| d['data'].to_i}
        #               expect(total_time).to eq(1)
        #             end
        #           end
        #         end
        #       end
        #     end
        #   end
        #   describe "取得したい学習状況の日付・集計モデルを指定する" do
        #     describe "GET /api/v1/users/:id?type=&year=&month=&day= #show" do
        #       it "2020年4月１日から一年のデータを集計" do
        #         get(api_v1_user_path(user.id),params:{type:"year",year:"2020",month:"4",day:"1"})
        #         res = JSON.parse(response.body)
        #         previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
        #         expect(previous_tasks.size).to eq 12
        #         expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("3月")
        #       end
        #       it "2020年7月１日から半年のデータを集計" do
        #         get(api_v1_user_path(user.id),params:{type:"6months",year:"2020",month:"7",day:"1"})
        #         res = JSON.parse(response.body)
        #         previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
        #         expect(previous_tasks.size).to eq 6
        #         expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("12月")
        #       end
        #       it "2021年1月1日から3ヶ月のデータを集計" do
        #         get(api_v1_user_path(user.id),params:{type:"3months",year:"2021",month:"1",day:"1"})
        #         res = JSON.parse(response.body)
        #          previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
        #         expect(previous_tasks.size).to eq 3
        #         expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("3月")
        #       end
        #       it "2021年5月1日から1ヶ月のデータを集計" do
        #         get(api_v1_user_path(user.id),params:{type:"month",year:"2021",month:"5",day:"1"})
        #         res = JSON.parse(response.body)
        #          previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
        #         expect(previous_tasks.size).to eq 31
        #         expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("5月31日")
        #       end
        #       it "2021年5月1日から1週間のデータを集計" do
        #         get(api_v1_user_path(user.id),params:{type:"week",year:"2021",month:"5",day:"1"})
        #         res = JSON.parse(response.body)
        #          previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
        #         expect(previous_tasks.size).to eq 7
        #         expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("5月7日")
        #       end
        #       it "2021年6月1日のデータを集計" do
        #         get(api_v1_user_path(user.id),params:{type:"day",year:"2021",month:"6",day:"1"})
        #         res = JSON.parse(response.body)
        #          previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
        #         expect(previous_tasks.size).to eq 1
        #         expect(previous_tasks[previous_tasks.size-1]["label"]).to eq("6月1日")
        #       end
        #     end
        #  end
        # end
    #     it "ステータスコード200が返ってくる" do
    #       get(api_v1_user_path(user.id))
    #       expect(response.status).to eq 200
    #     end
    #     it "ユーザ情報がレスポンスとして返ってくる" do
    #       get(api_v1_user_path(user.id))
    #       res = JSON.parse(response.body)
    #       res_user = User.find(res['data']['user']['id'])
    #       expect(res_user.class).to eq User
    #     end
    #     it "当日の学習計画の情報がレスポンスとして返ってくる" do
    #       get(api_v1_user_path(user.id))
    #       res = JSON.parse(response.body)
    #       now_time=Time.now
    #       expect(res['data']["draftLearns"]['nextTasks']['title']).to include("#{now_time.month}月#{now_time.day}日")
    #     end
    #     it "7日間の学習計画の情報がレスポンスとして返ってくる" do
    #       get(api_v1_user_path(user.id))
    #       res = JSON.parse(response.body)
    #       previous_tasks=res['data']["draftLearns"]['previousTasks']['data']
    #       expect(previous_tasks.size).to eq 7
    #     end
    #     it "当日の学習計画の情報がレスポンスとして返ってくる" do
    #       get(api_v1_user_path(user.id))
    #       res = JSON.parse(response.body)
    #       now_time=Time.now
    #       expect(res['data']["learns"]['nextTasks']['title']).to include("#{now_time.month}月#{now_time.day}日")
    #     end
    #     it "7日間の学習計画の情報がレスポンスとして返ってくる" do
    #       get(api_v1_user_path(user.id))
    #       res = JSON.parse(response.body)
    #       expect(res['data']["learns"]['previousTasks']['data'].size).to eq 7
    #     end
    #   end
    #   context "マイページにアクセスできない" do
    #     it "存在しないユーザ" do
    #       get(api_v1_user_path(10))
    #       res=JSON.parse(response.body)
    #       expect(res['errors']).to include "ユーザが存在しません"
    #     end
    #     it "ステータスコード401が返ってくる" do
    #       get(api_v1_user_path(10))
    #       expect(response.status).to eq 401
    #     end
    #   end
    # end
    # describe "ユーザ検索" do
    #   before do
    #     10.times do |n|
    #       FactoryBot.create(:"test_user#{n+1}")
    #     end
    #   end
    #   describe "get /api/v1/users/search?search=&id=" do
    #     context "検索結果がヒットする場合" do
    #       describe "「鈴木」と検索" do
    #         subject{get(search_api_v1_users_path,params:{id:user.id,keyword:"鈴木"})}
    #         it "ステータスコード200が返ってくる" do
    #           subject
    #           expect(response.status).to eq 200
    #         end
    #         it "3名のユーザがヒットする" do
    #           subject
    #           res=JSON.parse(response.body)
    #           expect(res['data']['users'].length).to eq 3
    #         end
    #         it "鈴木,鈴木龍弥,鈴木純也が含まれる" do
    #           subject
    #           res=JSON.parse(response.body)
    #           ary=res['data']['users'].map{|user|user['name']}
    #           expect(ary).to include("鈴木","鈴木龍弥","鈴木純也")
    #         end
    #         it "ログインユーザは含まれない" do
    #           subject
    #           res=JSON.parse(response.body)
    #           ary=res['data']['users'].map{|user|user['name']}
    #           expect(ary).not_to include(user.name)
    #         end
    #       end
    #       describe "「鈴木純也」と検索" do
    #         subject{get(search_api_v1_users_path,params:{id:user.id,keyword:"鈴木純也"})}
    #         it "ステータスコード200が返ってくる" do
    #           subject
    #           expect(response.status).to eq 200
    #         end
    #         it "1名のユーザがヒットする" do
    #           subject
    #           res=JSON.parse(response.body)
    #           expect(res['data']['users'].length).to eq 1
    #         end
    #         it "ログインユーザは含まれない" do
    #           subject
    #           res=JSON.parse(response.body)
    #           ary=res['data']['users'].map{|user|user['name']}
    #           expect(ary).not_to include(user.name)
    #         end
    #         describe "「ryo」と検索" do
    #           subject{get(search_api_v1_users_path,params:{id:user.id,keyword:"ryo"})}
    #           it "1名のユーザがヒットする" do
    #             subject
    #             res=JSON.parse(response.body)
    #             expect(res.size).to eq(1)
    #           end
    #           it "ログインユーザは含まれない" do
    #             subject
    #             res=JSON.parse(response.body)
    #             ary=res['data']['users'].map{|user|user['name']}
    #             expect(ary).not_to include(user.name)
    #           end
    #         end
    #       end
    #     end
    #     context "検索結果がヒットしない場合" do
    #       describe "そもそも空白・nil" do
    #         it "空白" do
    #           get(search_api_v1_users_path,params:{id:user.id,keyword:""})
    #           res=JSON.parse(response.body)
    #           expect(res['data']['message']).to include("文字列を入力をしてください。")
    #           expect(response.status).to eq 401
    #         end
    #         it "nil" do
    #           get(search_api_v1_users_path,params:{id:user.id,keyword:""})
    #           res=JSON.parse(response.body)
    #           expect(res['data']['message']).to include("文字列を入力をしてください。")
    #           expect(response.status).to eq 401
    #         end
    #       end
    #       describe "入力した文字列に一致するユーザが存在しない" do
    #         it "「suzuki」と検索" do
    #           get(search_api_v1_users_path,params:{id:user.id,keyword:"suzuki"})
    #           res=JSON.parse(response.body)
    #           expect(res['data']['message']).to include("検索結果がありません。")
    #           expect(response.status).to eq  200
    #         end
    #         it "「竹内智也」と検索" do
    #           get(search_api_v1_users_path,params:{id:user.id,keyword:"竹内智也"})
    #           res=JSON.parse(response.body)
    #           expect(res['data']['message']).to include("検索結果がありません。")
    #           expect(response.status).to eq  200
    #         end
    #       end
    #     end
    #   end
    # end
    describe "タイムライン" do
        context "分析機能" do
          before do
            @other_user=FactoryBot.create(:test_user1)
            [user,@other_user].each  do |u|
              25.times do |n|
                draft_learn=DraftLearn.new({id: nil, title: "test#{n}", content: "content#{n}", subject: "test", time: 1, created_at: nil, updated_at: nil,user_id:u.id})
                draft_learn.save!
                learn = Learn.new({id: nil, title: "test#{n}", content: "content#{n}", subject: "", time: 1, created_at: nil, updated_at: nil,draft_learn_id:draft_learn.id,user_id:u.id})
                subject=rand(4)
                case subject
                  when 0
                    draft_learn.subject="プログラミング"
                    learn.subject="プログラミング"
                  when 1
                    draft_learn.subject="英語"
                    learn.subject="英語"
                  when 2
                    draft_learn.subject="資格"
                    learn.subject="資格"
                  when 3
                    draft_learn.subject="その他"
                    learn.subject="その他"
                end
                draft_learn.created_at=Time.new("2020","1","1").since(n.day)
                draft_learn.save!
                learn.created_at=Time.new("2020","1","1").since(n.day)
                learn.save!
              end
            end
          end
          describe "GET /api/v1/users/:id/time_line?cuurent_page=&type=" do
            describe "ログインしているユーザのタイムラインを取得" do
              context "1ページ目" do
                context "testuserをフォローした場合"
                  before  do
                    post(api_v1_relationships_path,params:{follow_id:@other_user.id},headers:@params[:headers])
                  end
                  it "ステータスコードが200" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"BASIC"})
                    expect(response.status).to eq 200
                  end
                  it "データが30個、存在する" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"BASIC"})
                    res=JSON.parse(response.body)
                    expect(res['data']['timeLine'].length).to eq 30
                  end
                  it "testuserの投稿が存在する" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"BASIC"})
                    res=JSON.parse(response.body)
                    ary=res['data']['timeLine'].map{|time_line| time_line['user']['id']==@other_user.id}
                    expect(ary).to include(be_truthy)
                  end
                  context "type=MYONLYと指定した場合" do
                    it "testuserの投稿は存在しない" do
                      get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"MYONLY"})
                      res=JSON.parse(response.body)
                      my_only=res['data']['timeLine'].map{|time_line| time_line['user']['id']==@other_user.id}.all?
                      expect(my_only).to be_falsey
                    end
                    it "全てログインユーザの投稿である"do
                      get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"MYONLY"})
                      res=JSON.parse(response.body)
                      ary=res['data']['timeLine'].map{|time_line| time_line['user']['id']==user.id}
                    end
                  end
                  # いいね機能単体テスト・APIテスト後にかく
                  context "type=LIKEと指定した場合" do
                    before do
                      @date=@other_user.draft_learns[0].created_at
                      post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:@other_user.id},headers:@params[:headers])
                    end
                    it "データが1個、存在する" do
                      get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"LIKE"})
                      res=JSON.parse(response.body)
                      expect(res['data']['timeLine'].length).to eq 1
                    end
                    it "いいね解除したら、データは空" do
                      delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:@other_user.id},headers:@params[:headers])
                      get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"LIKE"})
                      res=JSON.parse(response.body)
                      expect(res['data']['timeLine'].length).to eq 0
                    end
                  end
                end
                context "testuserをフォローしていない場合場合" do
                  it "testuserの投稿が存在しない" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:1,type:"BASIC"})
                    res=JSON.parse(response.body)
                    my_only=res['data']['timeLine'].map{|time_line| time_line['user']['id']==@other_user.id}.all?
                    expect(my_only).to be_falsey
                  end
                end
              end
              context "2ページ目" do
                context "testuserをフォローした場合" do
                  before  do
                    post(api_v1_relationships_path,params:{follow_id:@other_user.id},headers:@params[:headers])
                  end
                  it "ステータスコードが200" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:2,type:"BASIC"})
                    expect(response.status).to eq 200
                  end
                  it "データが30個、存在する" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:2,type:"BASIC"})
                    res=JSON.parse(response.body)
                    expect(res['data']['timeLine'].length).to eq 30
                  end
                  it "testuserの投稿が存在する" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:2,type:"BASIC"})
                    res=JSON.parse(response.body)
                    ary=res['data']['timeLine'].map{|time_line| time_line['user']['id']==@other_user.id}
                    expect(ary).to include(be_truthy)
                  end
                  # いいね機能単体テスト・APIテスト後にかく
                  # context "type=LIKEと指定した場合" do
                  # end
                end
                context "testuserをフォローしていない場合" do
                  it "testuserの投稿が存在しない" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:2,type:"BASIC"})
                    res=JSON.parse(response.body)
                    my_only=res['data']['timeLine'].map{|time_line| time_line['user']['id']==@other_user.id}.all?
                    expect(my_only).to be_falsey
                  end
                  it "データの個数20ある" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:2,type:"BASIC"})
                    res=JSON.parse(response.body)
                    expect(res['data']['timeLine'].length).to eq 20
                  end
                end
              end
              context "4ページ目"do
                context "testuserをフォローした場合"do
                  before do
                    post(api_v1_relationships_path,params:{follow_id:@other_user.id},headers:@params[:headers])
                  end
                  it "データが10個、存在する" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:4,type:"BASIC"})
                    res=JSON.parse(response.body)
                    expect(res['data']['timeLine'].length).to eq 10
                  end
                end
                context "testuserをフォローしなかった場合" do
                  it "ページが存在し無い" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:4,type:"BASIC"})
                    expect(response.status).to eq 401
                  end
                  it "「ページが存在しません」というメッセージを含む" do
                    get(time_line_api_v1_user_path(user.id),params:{cuurent_page:200,type:"BASIC"})
                    res=JSON.parse(response.body)
                    expect(res['data']['message']).to eq "ページが存在しません。"
                  end
                end
              end
              context "ページが存在しない場合" do
                it "ステータスコードが401" do
                  get(time_line_api_v1_user_path(user.id),params:{cuurent_page:200,type:"BASIC"})
                  expect(response.status).to eq 401
                end
                it "「ページが存在しません」というメッセージを含む" do
                  get(time_line_api_v1_user_path(user.id),params:{cuurent_page:200,type:"BASIC"})
                  res=JSON.parse(response.body)
                  expect(res['data']['message']).to eq "ページが存在しません。"
                end
              end
            end
        end
    end
  end
end

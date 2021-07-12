require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:cuurent_user){FactoryBot.create(:test_user2)}
  let(:other_user){FactoryBot.create(:test_user1)}
  before do
    [cuurent_user,other_user].each do |u|
      5.times do |n|
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
    @params=auth_post cuurent_user, api_v1_user_session_path,
    params:{
      email:cuurent_user.email,
      password:"000000"
    }
  end

  describe "いいね機能" do
    describe "いいねする" do
      describe "POST api/v1/likes#create" do
        context "他のユーザをいいねした場合" do
          before do
            @date=other_user.draft_learns[0].created_at
          end
          it "ステータスコード200が返ってくる" do
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:other_user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
          it "いいね数が増える" do
            before_like_count=Like.all.count
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:other_user.id},headers:@params[:headers])
            expect(before_like_count<Like.all.count).to be_truthy
          end
        end
        context "自分の投稿をいいねした場合"do
          before do
            @date=cuurent_user.draft_learns[0].created_at
          end
          it "ステータスコード200が返ってくる" do
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
          it "いいね数が増える" do
            before_like_count=Like.all.count
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            expect(before_like_count<Like.all.count).to be_truthy
          end
          describe "投稿が存在しない場合" do
            it "ステータスコード401が返ってる" do
              post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:Time.now,other_user:cuurent_user.id},headers:@params[:headers])
              expect(response.status).to eq 401
            end
            it "「投稿が存在しません」というメッセージを含む" do
              post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:Time.now,other_user:cuurent_user.id},headers:@params[:headers])
              res = JSON.parse(response.body)
              expect(res['data']['message']).to eq "投稿が存在しません"
            end
          end
        end
        context "いいねした投稿をもう一度いいねした場合" do
          before do
            @date=cuurent_user.draft_learns[0].created_at
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
          end
          it "ステータスコード200が返ってくる" do
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
          it "いいね数は変わらない" do
            before_like_count=Like.all.count
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            expect(before_like_count==Like.all.count).to be_truthy
          end
        end
      end
      context "通知" do
      end
    end
    describe "いいねを解除する" do
      describe "DELETE api/v1/likes#destroy" do
        context "他のユーザをいいねを解除した場合" do
          before do
            @date=other_user.draft_learns[0].created_at
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:other_user.id},headers:@params[:headers])
          end
          it "ステータスコード200が返ってくる" do
            delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:other_user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
          it "いいね数は減る" do
            before_like_count=Like.all.count
            delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:other_user.id},headers:@params[:headers])
            expect(before_like_count>Like.all.count).to be_truthy
          end
        end
        context "自分の投稿をいいねを解除した場合"do
          before do
            @date=cuurent_user.draft_learns[0].created_at
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
          end
          it "ステータスコード200が返ってくる" do
            delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            expect(response.status).to eq 200
          end
          it "いいね数は減る" do
            before_like_count=Like.all.count
            delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            expect(before_like_count>Like.all.count).to be_truthy
          end
        end
        context "いいねを解除した投稿に対して、もう一度いいねを解除した場合" do
          before do
            @date=cuurent_user.draft_learns[0].created_at
            post(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
          end
          it "ステータスコード401が返ってくる" do
            delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            expect(response.status).to eq 401
          end
          it "「投稿が存在しません」というメッセージを含む" do
            delete(api_v1_likes_path,params:{type:"DRAFTLEARN",date:@date,other_user:cuurent_user.id},headers:@params[:headers])
            res = JSON.parse(response.body)
            expect(res['data']['message']).to eq "投稿が存在しません"
          end
        end
        context "通知を削除する" do
        end
      end
    end
  end
end

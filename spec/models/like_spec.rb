require 'rails_helper'
RSpec.describe Like, type: :model do
  let(:cuurent_user){FactoryBot.create(:test_user2)}
  let(:other_user){FactoryBot.create(:test_user1)}
  describe "いいね機能" do
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
    end
    describe "いいねする" do
      describe "自分の投稿にいいねする。" do
        context "DraftLearn" do
          before do
            date=cuurent_user.draft_learns[0].created_at
            d=[date.year,date.month,date.day]
            @likeing_contents,@model=cuurent_user.likeing_type("DRAFTLEARN",d)
          end
          it "いいね数が増える" do
            before_like_count=Like.all.count
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
            expect(before_like_count<Like.all.count).to be_truthy
          end
        end
        context "Learn" do
          before do
            date=cuurent_user.learns[0].created_at
            d=[date.year,date.month,date.day]
            @likeing_contents,@model=cuurent_user.likeing_type("LEARN",d)
          end
          it "いいね数が増える" do
            before_like_count=Like.all.count
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
            expect(before_like_count<Like.all.count).to be_truthy
          end
        end
      end
      context "他人の投稿にいいねする。" do
        context "DraftLearn" do
          before do
            date=other_user.learns[0].created_at
            d=[date.year,date.month,date.day]
            @likeing_contents,@model=other_user.likeing_type("LEARN",d)
          end
          it "いいね数が増える" do
            before_like_count=Like.all.count
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
            expect(before_like_count<Like.all.count).to be_truthy
          end
        end
        context "Learn" do
          before do
            date=other_user.learns[0].created_at
            d=[date.year,date.month,date.day]
            @likeing_contents,@model=other_user.likeing_type("LEARN",d)
          end
          it "いいね数が増える" do
            before_like_count=Like.all.count
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
            expect(before_like_count<Like.all.count).to be_truthy
          end
        end
      end
    end
    describe "いいねを解除する" do
      context "自分の投稿のいいねを解除する" do
        context "DraftLearn" do
          before do
            date=cuurent_user.draft_learns[0].created_at
            @d=[date.year,date.month,date.day]
            @likeing_contents,@model=cuurent_user.likeing_type("DRAFTLEARN",@d)
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
          end
          it "いいね数が減る" do
            likeing_contents,model=cuurent_user.unlike_type("DRAFTLEARN",cuurent_user,@d)
            before_like_count=Like.all.count
            Like.likeing_destroys(likeing_contents,model)
            expect(before_like_count>Like.all.count).to be_truthy
          end
        end
        context "Learn" do
          before do
            date=cuurent_user.draft_learns[0].created_at
            @d=[date.year,date.month,date.day]
            @likeing_contents,@model=cuurent_user.likeing_type("LEARN",@d)
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
          end
          it "いいね数が減る" do
            likeing_contents,model=cuurent_user.unlike_type("LEARN",cuurent_user,@d)
            before_like_count=Like.all.count
            Like.likeing_destroys(likeing_contents,model)
            expect(before_like_count>Like.all.count).to be_truthy
          end
        end
      end
      context "他のユーザの投稿のいいねを解除する" do
        context "DraftLearn" do
          before do
            date=other_user.draft_learns[0].created_at
            @d=[date.year,date.month,date.day]
            @likeing_contents,@model=other_user.likeing_type("DRAFTLEARN",@d)
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
          end
          it "いいね数が減る" do
            likeing_contents,model=cuurent_user.unlike_type("DRAFTLEARN",other_user,@d)
            before_like_count=Like.all.count
            Like.likeing_destroys(likeing_contents,model)
            expect(before_like_count>Like.all.count).to be_truthy
          end
        end
        context "Learn" do
          before do
            date=other_user.draft_learns[0].created_at
            @d=[date.year,date.month,date.day]
            @likeing_contents,@model=other_user.likeing_type("LEARN",@d)
            Like.likeing_saves(@likeing_contents,@model,cuurent_user)
          end
          it "いいね数が減る" do
            likeing_contents,model=cuurent_user.unlike_type("LEARN",other_user,@d)
            before_like_count=Like.all.count
            Like.likeing_destroys(likeing_contents,model)
            expect(before_like_count>Like.all.count).to be_truthy
          end
        end
      end
    end
  end
end

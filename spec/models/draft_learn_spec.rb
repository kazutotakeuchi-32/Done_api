require 'rails_helper'

RSpec.describe DraftLearn, type: :model do
  let(:user){FactoryBot.create(:user)}
  let(:draft_learn){FactoryBot.build(:draft_learn,user_id:user.id)}
  describe "学習計画投稿" do
    context '投稿に成功する場合' do
      it "タスク名、学習時間,学習内容、カテゴリーが全て存在する" do
        expect(draft_learn).to be_valid
      end
      it "投稿数が増える" do
        expect{draft_learn.save}.to change(DraftLearn, :count).from(0).to(1)
      end
      it "タスク名が存在する" do
        draft_learn.title="PHPの基礎文法を学習する"
        expect(draft_learn).to be_valid
      end
      it "学習時間が存在する" do
        draft_learn.time=0
        expect(draft_learn).to be_valid
      end
      it "学習内容が存在する" do
        draft_learn.content="プロゲートのPHPシリーズをクリアする。"
        expect(draft_learn).to be_valid
      end
      it "カテゴリーが存在する" do
        draft_learn.subject="プロゲート"
        expect(draft_learn).to be_valid
      end
      it "user_idが存在する" do
        draft_learn.user_id=user.id
        expect(draft_learn).to be_valid
      end
    end
    context "投稿に失敗する場合" do
      it "タスク名、学習時間,学習内容、カテゴリーが全て存在しない" do
        draft_learn.title=nil
        draft_learn.time=nil
        draft_learn.content=nil
        draft_learn.subject=nil
        draft_learn.user_id=nil
        draft_learn.valid?
        expect(draft_learn).to be_invalid
        expect(draft_learn.errors.full_messages).to include("Titleを入力してください","Timeを入力してください","Subjectを入力してください","Userを入力してください")
      end
      it "タスク名が存在しない" do
        draft_learn.title=nil
        draft_learn.valid?
        expect(draft_learn).to be_invalid
        expect(draft_learn.errors.full_messages).to include("Titleを入力してください")
      end
      it "学習時間が存在しない" do
        draft_learn.time=nil
        draft_learn.valid?
        expect(draft_learn).to be_invalid
        expect(draft_learn.errors.full_messages).to include("Timeを入力してください")
      end
      it "学習内容が存在しない" do
        draft_learn.content=nil
        draft_learn.valid?
        expect(draft_learn).to be_invalid
        expect(draft_learn.errors.full_messages).to include("Contentを入力してください")
      end
      it "カテゴリーが存在しない" do
        draft_learn.subject=nil
        draft_learn.valid?
        expect(draft_learn).to be_invalid
        expect(draft_learn.errors.full_messages).to include("Subjectを入力してください")
      end
      it "user_idが存在しない" do
        draft_learn.user_id=nil
        draft_learn.valid?
        expect(draft_learn).to be_invalid
        expect(draft_learn.errors.full_messages).to include("Userを入力してください")
      end
    end
  end
  describe "分析機能" do
  end
end

require 'rails_helper'

RSpec.describe Learn, type: :model do
  let(:user){FactoryBot.create(:user)}
  let(:draft_learn){FactoryBot.create(:draft_learn,user_id:user.id)}
  let(:learn){FactoryBot.build(:learn ,draft_learn_id:draft_learn.id,user_id:user.id)}
  describe "学習完了投稿" do
    context "投稿に成功する場合" do
      it "タスク名、学習時間,学習内容、カテゴリーが全て存在する" do
        expect(learn).to be_valid
      end
      it "投稿数が増える" do
        expect{learn.save}.to change(DraftLearn, :count).from(0).to(1)
      end
      it "タスク名が存在する" do
        learn.title="PHPの基礎文法を学習する"
        expect(learn).to be_valid
      end
      it "学習時間が存在する" do
        learn.time=0
        expect(learn).to be_valid
      end
      it "学習内容が存在する" do
        learn.content="プロゲートのPHPシリーズをクリアする。"
        expect(learn).to be_valid
      end
      it "カテゴリーが存在する" do
        learn.subject="プロゲート"
        expect(learn).to be_valid
      end
      it "draft_learn_idが存在する" do
        learn.draft_learn_id=draft_learn.id
        expect(learn).to be_valid
      end
      it "user_idが存在する" do
        learn.user_id=user.id
        expect(learn).to be_valid
      end
    end
    context "投稿に失敗する場合" do
      it "タスク名、学習時間,学習内容、カテゴリーが全て存在しない" do
        learn.title=nil
        learn.time=nil
        learn.content=nil
        learn.subject=nil
        learn.user_id=nil
        learn.draft_learn_id=nil
        learn.valid?
        expect(learn).to be_invalid
        expect(learn.errors.full_messages).to include("Titleを入力してください","Timeを入力してください","Subjectを入力してください","Userを入力してください","Draft learnを入力してください")
      end
      it "タスク名が存在しない" do
        learn.title=nil
        learn.valid?
        expect(learn).to be_invalid
        expect(learn.errors.full_messages).to include("Titleを入力してください")
      end
      it "学習時間が存在しない" do
        learn.time=nil
        learn.valid?
        expect(learn).to be_invalid
        expect(learn.errors.full_messages).to include("Timeを入力してください")
      end
      it "学習内容が存在しない" do
        learn.content=nil
        learn.valid?
        expect(learn).to be_invalid
        expect(learn.errors.full_messages).to include("Contentを入力してください")
      end
      it "カテゴリーが存在しない" do
        learn.subject=nil
        learn.valid?
        expect(learn).to be_invalid
        expect(learn.errors.full_messages).to include("Subjectを入力してください")
      end
      it "user_idが存在しない" do
        learn.user_id=nil
        learn.valid?
        expect(learn).to be_invalid
        expect(learn.errors.full_messages).to include("Userを入力してください")
      end
      it "draft_learn_idが存在しない" do
        learn.draft_learn_id=nil
        learn.valid?
        expect(learn).to be_invalid
        expect(learn.errors.full_messages).to include("Draft learnを入力してください")
      end
    end
  end
end

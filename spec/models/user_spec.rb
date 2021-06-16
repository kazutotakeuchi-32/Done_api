require 'rails_helper'
# describeテストのグループ分け
# context 条件に応じてグループを分ける
RSpec.describe User, type: :model do
  # テストが走る前に実行される
  # example...テスト実行後ロールバックされる
  # context...テスト実行後ロールバックされない
  let(:valid_email_regex) {/\A[\w+-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i}
  before(:example) do
    @user =FactoryBot.build(:user)
  end
  describe "アカウント登録" do
    subject{@user}
    context 'アカウント登録に成功する場合' do
      it "名前、email,パスワード,パスワード確認が全て存在する" do
        expect(@user).to be_valid
      end

      it "ユーザ数が増える" do
        expect{@user.save}.to change(User, :count).from(0).to(1)
      end

      it "名前が存在する" do
        @user.name="tanaka"
        expect(@user).to be_valid
      end

      it "emailが存在する" do
        @user.email = "kazutotakeuchi@gmail.com"
        expect(@user).to be_valid
      end

      it "emailが正しい形式である" do
        ["kazutotakeuchi@gmail.com","kazuto@ezweb.ne.jp","hogehoge@example.com"].each do |email|
          @user.email=email
          expect(@user).to be_valid
        end
      end

      it "emailのパターン" do
        ["kazutotakeuchi@gmail.com","kazuto@ezweb.ne.jp","hogehoge@example.com"].each do |email|
          expect(email).to match(valid_email_regex)
        end
      end

      it "パスワードが6文字以上である" do
        @user.password = "1111111"
        @user.password_confirmation="1111111"
        expect(@user).to be_valid
      end

      it "passwordとpassword_confirmation値が等しい" do
        @user.password = "1111111"
        @user.password_confirmation="1111111"
        expect(@user.password==@user.password_confirmation).to be_truthy
        expect(@user).to be_valid
      end
    end
    context 'アカウント登録に失敗する場合' do
      it "nameが空白である" do
        @user.name=""
        expect(@user).to be_invalid
        expect(@user.errors[:name]).to include("を入力してください")
      end
      it "ユーザ数が増えない" do
        @user.name=""
        @user.save
        expect(User.count).to eq(0)
      end
      it "emailが空白である" do
        @user.email=""
        expect(@user).to be_invalid
        expect(@user.errors[:email]).to include("を入力してください")
      end
      it "passwordが空白である" do
        @user.password=""
        @user.password_confirmation=""
        expect(@user).to be_invalid
        expect(@user.errors[:password]).to include("を入力してください")
      end
      it "emailが正しい形式ではない" do
        invalid_emails = ["kazutp..com","kazutotakeuchi@..com","test.com","hoge","kazutotakeuchi@.ff.com"]
        invalid_emails.each do |email|
          @user.email = email
          expect(@user).to be_invalid
          expect(@user.errors[:email]).to include("は有効ではありません")
        end
      end
      it "emailのアンチパターン" do
        invalid_emails = ["kazutp..com","kazutotakeuchi@..com","test.com","hoge","kazutotakeuchi@.ff.com"]
        invalid_emails.each do |email|
          expect(email).not_to match(valid_email_regex)
        end
      end
      it "passwordが6文字以下である" do
        @user.password = "11111"
        @user.password_confirmation="11111"
        expect(@user).to be_invalid
        expect(@user.errors[:password]).to include("は6文字以上で入力してください")
      end
      it "passwordとpassword_confirmation値が等しくない" do
        @user.password = "11111111"
        @user.password_confirmation="1111111"
        expect(@user.password==@user.password_confirmation).to be_falsey
        expect(@user).to be_invalid
        expect(@user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
      it "同じEmailアドレスは登録できない" do
        @user.save
        other_user=FactoryBot.build(:user)
        expect(other_user).to be_invalid
        expect(other_user.errors.full_messages).to include("Eメールはすでに存在します")
      end
    end
  end
end



# it "それ自体と等しい" do
#   expect(@user).to be(@user)
# end

#   it "is a new widget" do
#     @user
#    user= User.new
#    expect(user).to be_a_new(User)
#  end

#  it "is a new String" do
#    na=Na.new("na",1)
#    p na
#    # expect(na).to be_a_new(Na)
#  end

# it "そもそもユーザが存在しない" do
#   expect(User.count).to(eq 0)
# end
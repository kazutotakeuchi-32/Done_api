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

  describe "ユーザ検索機能" do
    """
    テストユーザ名
    田村悠人
    田村仁
    鈴木龍弥
    鈴木純也
    鈴木
    竹内和人
    jun
    ryo
    yui
    """
    before do
      10.times do |n|
        FactoryBot.create(:"test_user#{n+1}")
      end
    end
    let(:current_user){User.find_by(name:"竹内和人")}
    context "検索がヒットする場合" do
        describe "「鈴木」と検索" do
          subject{User.search("鈴木",current_user.id)}
          it "3名のユーザがヒットする" do
            result=subject
            expect(result.size).to eq(3)
          end
          it "鈴木,鈴木龍弥,鈴木純也が含まれる" do
            result=subject
            ary=result.map{|user|user.name}
            expect(ary).to include("鈴木","鈴木龍弥","鈴木純也")
          end
          it "ログインユーザは含まれない" do
            result=subject
            ary=result.map{|user|user.name}
            expect(ary).not_to include(current_user.name)
          end
          it "田村悠人は含まれない" do
            result=subject
            ary=result.map{|user|user.name}
            expect(ary).not_to include("田村悠人")
          end
        end
        describe "「鈴木純也」と検索" do
          subject{User.search("鈴木純也",current_user.id)}
          it "1名のユーザがヒットする" do
            result=subject
            expect(result.size).to eq(1)
          end
          it "鈴木が含まれない" do
            result=subject
            ary=result.map{|user|user.name}
            expect(ary).not_to include("鈴木")
          end
          it "ログインユーザは含まれない" do
            result=subject
            ary=result.map{|user|user.name}
            expect(ary).not_to include(current_user.name)
          end
        end
        describe "「田村」と検索" do
          subject{User.search("田村",current_user.id)}
          it "2名のユーザがヒットする" do
            result=subject
            expect(result.size).to eq(2)
          end
          it "ログインユーザは含まれない" do
            result=subject
            ary=result.map{|user|user.name}
            expect(ary).not_to include(current_user.name)
          end
        end
        describe "「ryo」と検索" do
          subject{User.search("ryo",current_user.id)}
          it "1名のユーザがヒットする" do
            result=subject
            expect(result.size).to eq(1)
          end
          it "ログインユーザは含まれない" do
            result=subject
            ary=result.map{|user|user.name}
            expect(ary).not_to include(current_user.name)
          end
        end
      end
      context "検索がヒットしない場合" do
        subject{User.search("test",current_user.id)}
        describe "「test」と検索" do
          it "空の配列が返り値として返ってくる" do
            result=subject
            expect(result).to be_empty
          end
        end
        context "ログインユーザを検索する場合" do
          subject{User.search(current_user.name,current_user.id)}
          it "空の配列が返り値として返ってくる" do
            result=subject
            expect(result).to be_empty
          end
        end
      end
    end
    describe "フォロー機能" do

    end
end

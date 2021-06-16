require 'rails_helper'
RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  let(:params) { FactoryBot.attributes_for(:user).merge(confirm_success_url:"http://localhost:3001/") }
  describe "アカウント登録" do
    describe "POST /api/v1/auth #create" do
      context "アカウント登録に成功する" do
        subject { post(api_v1_user_registration_path, params: params) }
        it "全カラムの値が正しい" do
          subject
          expect(response.status).to eq 200
          res=JSON.parse(response.body)
        end
        it "JSONレスポンス値に入力した名前が含まれる" do
          subject
          res=JSON.parse(response.body)
          expect(res['data']['name']).to eq params[:name]
        end
        it "JSONレスポンス値に入力したemailが含まれる" do
          subject
          res=JSON.parse(response.body)
          expect(res['data']['email']).to eq params[:email]
        end
      end
      context "アカウント登録に失敗する" do
        it "password_confirmationの値がpasswordと異なるとき" do
          params[:password_confirmation]="0"
          post(api_v1_user_registration_path, params: params)
          res = JSON.parse(response.body)
          expect(res['errors']['full_messages']).to include("パスワード（確認用）とパスワードの入力が一致しません")
          expect(response.status).to eq 422
        end
        it "nameが空白である" do
          params[:name]=""
          post(api_v1_user_registration_path, params: params)
          res = JSON.parse(response.body)
          expect(res['errors']['full_messages']).to include("Nameを入力してください")
          expect(response.status).to eq 422
        end
        it "emailが空白" do
          params[:email]=""
          post(api_v1_user_registration_path, params: params)
          res = JSON.parse(response.body)
          expect(res['errors']['full_messages']).to include("Eメールを入力してください","Eメールは不正な値です")
          expect(response.status).to eq 422
        end
        it "同じEmailアドレスが既に登録されている" do
          post(api_v1_user_registration_path, params: params)
          post(api_v1_user_registration_path, params: params)
          expect(response.status).to eq 422
          res = JSON.parse(response.body)
          expect(res["errors"]["full_messages"]).to include("Eメールはすでに存在します")
        end
        it "リクエストパラメータが空" do
          post(api_v1_user_registration_path, params: {})
          expect(response.status).to eq 422
          res = JSON.parse(response.body)
          expect(res["errors"]).to include("リクエストボディに適切なアカウント新規登録データを送信してください。")
        end
      end
    end
  end

  describe "アカウント設定" do
    let(:user) { FactoryBot.create(:other) }
    before do
      @params=auth_post user, api_v1_user_session_path,
      params:{
        email:user.email,
        password:"000000"
      }
    end
    describe "PUT /api/v1/auth #update" do
        context "アカウント設定ができる" do
          describe "ログインしている" do
            it "名前を変更できる" do
              put api_v1_user_registration_path ,params:{name:"jun"},headers:@params[:headers]
              res = JSON.parse(response.body)
              expect(response.status).to eq 200
              expect(res['data']['name']).to include("jun")
            end
            it "Emailアドレスを変更できる" do
              put api_v1_user_registration_path ,params:{email:"jun@gmail.com"},headers:@params[:headers]
              res = JSON.parse(response.body)
              expect(response.status).to eq 200
              expect(res['data']['email']).to include("jun@gmail.com")
            end
            it "アバターを変更できる" do
              put api_v1_user_registration_path ,params:{avatar:"profile.png"},headers:@params[:headers]
              res = JSON.parse(response.body)
              expect(response.status).to eq 200
              expect(res['data']['avatar']).to include("profile.png")
            end
            it "全て変更できる" do
              put api_v1_user_registration_path ,params:{name:"jun",email:"jun@gmail.com",avatar:"profile.png"},headers:@params[:headers]
              res = JSON.parse(response.body)
              expect(response.status).to eq 200
              expect(res['data']['name']).to include("jun")
              expect(res['data']['email']).to include("jun@gmail.com")
              expect(res['data']['avatar']).to include("profile.png")
            end
            context "ログインしてから14日以内" do
              around do |e|
                travel_to('2021-2-29 10:00'.to_time){ e.run }
              end
              it "14日以内であれば変更できる" do
                travel 13.day
                put api_v1_user_registration_path ,params:{name:"jun"},headers:@params[:headers]
                res = JSON.parse(response.body)
                expect(response.status).to eq 200
                expect(res['data']['name']).to include("jun")
              end
            end
          end
        end
        context "アカウント設定ができない" do
          describe "ログインしていない" do
            it "ログインしていないユーザはアカウント設定できない" do
              other_user=FactoryBot.create(:no_login_user)
              put api_v1_user_registration_path ,params:{name:"jun",email:"jun@gmail.com",avatar:"profile.png"},headers:{}
              expect(response.status).to eq 404
              res = JSON.parse(response.body)
              expect(res['errors']).to include("ユーザーが見つかりません。")
            end
          end
          describe "ログインしている" do
            context "ログインしてから14日後" do
              around do |e|
                travel_to('2021-2-29 10:00'.to_time){ e.run }
              end
              it "14日を過ぎるとログアウトできない" do
                travel 14.day
                put api_v1_user_registration_path ,params:{name:"jun"},headers:@params[:headers]
                res = JSON.parse(response.body)
                expect(response.status).to eq(404)
                expect(res['errors']).to include("ユーザーが見つかりません。")
              end
            end
          end
       end
    end
  end

  describe "パスワード変更する" do
    let(:user) { FactoryBot.create(:other) }
    before do
      @params=auth_post user, api_v1_user_session_path, params:{email:user.email,password:"000000"}
    end
    describe "POST /api/v1/auth/password #create" do
      describe "パスワードリセット確認メール" do
        context "確認メールを送信ができる" do
          it "Emailアドレスが存在する。" do
            post api_v1_user_password_path,params:{email:user.email,redirect_url:"http://localhost:3001/confirmation/password"}
            res = JSON.parse(response.body)
            expect(response.status).to eq 200
            expect(res['message']).to include ('にパスワードリセットの案内が送信されました。')
          end
        end
        context "確認メールを送信ができない" do
          it "Emailアドレスが存在しない" do
            post api_v1_user_password_path,params:{email:"ka@example.com",redirect_url:"http://localhost:3001/confirmation/password"}
            res = JSON.parse(response.body)
            expect(response.status).to eq 404
            expect(res['errors']).to include ("メールアドレス 'ka@example.com' のユーザーが見つかりません。")
          end
          it "Emailアドレスが指定されていない" do
            post api_v1_user_password_path,params:{email:nil,redirect_url:"http://localhost:3001/confirmation/password"}
            res = JSON.parse(response.body)
            expect(response.status).to eq 401
            expect(res['errors']).to include ("メールアドレスが与えられていません。")
          end
          it "redirect_urlが指定されていない" do
            post api_v1_user_password_path,params:{email:"ka@example.com",redirect_url:nil}
            res = JSON.parse(response.body)
            expect(response.status).to eq 401
            expect(res['errors']).to include ("リダイレクト URL が与えられていません。")
          end
        end
      end
    end
    describe "PUT /api/v1/auth/password #update" do
      describe "パスワード変更" do
        context "パスワードが変更できる" do
            it "tokenが存在する" do
              put api_v1_user_password_path,params:{password:"999999",password_confirmation:"999999"},headers:@params[:headers]
              res = JSON.parse(response.body)
              expect(response.status).to eq(200)
              expect(res['message']).to include("パスワードの更新に成功しました。")
            end
            it "変更したパスワードでログインができる" do
              put api_v1_user_password_path,params:{password:"999999",password_confirmation:"999999"},headers:@params[:headers]
              res = JSON.parse(response.body)
              res=auth_post user, api_v1_user_session_path, params:{email:@params[:params][:email],password:"999999"}
              expect(res[:status]).to eq(200)
           end
           it "パスワード変更後、変更前のパスワードではログインができない" do
             put api_v1_user_password_path,params:{password:"999999",password_confirmation:"999999"},headers:@params[:headers]
             res = JSON.parse(response.body)
             res=auth_post user, api_v1_user_session_path, params:{email:@params[:params][:email],password:@params[:params][:password]}
             res2 = JSON.parse(response.body)
             expect(res[:status]).to eq(401)
             expect(res2['errors']).to include("ログイン用の認証情報が正しくありません。再度お試しください。")
           end
        end
        context "パスワードが変更できない" do
          it "headersが空" do
            put api_v1_user_password_path,params:{password:"999999",password_confirmation:"999999"},headers:{}
            res = JSON.parse(response.body)
            expect(response.status).to eq(401)
            expect(res['errors']).to include("Unauthorized")
          end
          it "passwordとpassword_confirmationの値が違う" do
            put api_v1_user_password_path,params:{password:"999999",password_confirmation:"999000000"},headers:@params[:headers]
            res = JSON.parse(response.body)
            expect(response.status).to eq(422)
            expect(res['errors']['full_messages']).to include("パスワード（確認用）とパスワードの入力が一致しません")
          end
          it "パスワードが6文字以内" do
            put api_v1_user_password_path,params:{password:"99",password_confirmation:"99"},headers:@params[:headers]
            res = JSON.parse(response.body)
            expect(response.status).to eq(422)
            expect(res['errors']['full_messages']).to include("パスワードは6文字以上で入力してください")
          end
          context "ログインしてから14日後" do
            around do |e|
              travel_to('2021-2-29 10:00'.to_time){ e.run }
            end
            it "tokenの有効期限が過ぎた" do
              travel 15.day
              put api_v1_user_password_path,params:{password:"999999",password_confirmation:"999000000"},headers:@params[:headers]
              res = JSON.parse(response.body)
              expect(response.status).to eq 401
              expect(res['errors']).to include("Unauthorized")
            end
          end
        end
      end
    end
  end
end

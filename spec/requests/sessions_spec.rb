require 'rails_helper'
RSpec.describe "Sessions", type: :request do
  let(:params) { FactoryBot.attributes_for(:user).merge(confirm_success_url:"http://localhost:3001/") }
  describe "ログイン" do
    context "ログインに成功する" do
      describe "メール認証済み" do
        let(:user) { FactoryBot.create(:other) }
        subject {auth_post user, api_v1_user_session_path, params: params }
        it "アカウントを有効化したユーザのみログインができる" do
           res=subject
           expect(res[:status]).to eq 200
        end
        it "レスポンスヘッダにaccess-tokenが存在する" do
          res=subject
          expect(res[:headers]).to have_key('access-token')
        end
        it "レスポンスヘッダにclientが存在する" do
          res=subject
          expect(res[:headers]).to have_key('client')
        end
        it "レスポンスヘッダにuidが存在する" do
          res=subject
          expect(res[:headers]).to have_key('uid')
        end
      end

    end
    context "ログインに失敗する" do
      context "メール認証が行われていないユーザ" do
        subject { post(api_v1_user_registration_path, params: params) }
        it "確認用のメールが送信される" do
          subject
          post(api_v1_user_session_path,params:{email:params[:email],password:params[:password]})
          res = JSON.parse(response.body)
          expect(res['errors'][0]).to include("に確認用のメールを送信しました。メール内の説明を読み、アカウントの有効化をしてください。")
        end
        it "ステータスコード401が返ってくる" do
          subject
          post(api_v1_user_session_path,params:{email:params[:email],password:params[:password]})
          expect(response.status).to eq(401)
        end
      end

      context "メール認証済みのユーザ" do
        let(:user) { FactoryBot.create(:other) }

        describe "未入力" do
          it "空のパラメータ" do
            post(api_v1_user_session_path,params:{})
            res = JSON.parse(response.body)
            expect(response.status).to eq(401)
            expect(res['errors']).to include("ログイン用の認証情報が正しくありません。再度お試しください。")
          end
          it "emailが未入力" do
            post(api_v1_user_session_path,params:{email:{},password:params[:password]})
            res = JSON.parse(response.body)
            expect(response.status).to eq(401)
            expect(res['errors']).to include("ログイン用の認証情報が正しくありません。再度お試しください。")
          end
          it "passwordが未入力" do
            post(api_v1_user_session_path,params:{email:user.email,password:{}})
            res = JSON.parse(response.body)
            expect(response.status).to eq(401)
            expect(res['errors']).to include("ログイン用の認証情報が正しくありません。再度お試しください。")
          end
        end

        describe "認証に失敗" do
          it "passwordが違う" do
            post(api_v1_user_session_path,params:{email:user.email,password:"11"})
            res = JSON.parse(response.body)
            expect(response.status).to eq(401)
            expect(res['errors']).to include("ログイン用の認証情報が正しくありません。再度お試しください。")
          end
          it "存在しないemailアドレス" do
            post(api_v1_user_session_path,params:{email:"kawekfokofek@gmail.com",password:"11"})
            res = JSON.parse(response.body)
            expect(response.status).to eq(401)
            expect(res['errors']).to include("ログイン用の認証情報が正しくありません。再度お試しください。")
          end
        end
      end
    end
  end
  describe "ログアウト" do
    let(:user) { FactoryBot.create(:other) }
    before do
      @params=auth_post user, api_v1_user_session_path, params:{email:user.email,password:params[:password]}
    end
    context "ログアウトに成功する" do
      describe "ログインをしている" do
        it "uid,access-token,clientの値が正しい" do
          delete(destroy_api_v1_user_session_path,headers:@params[:headers])
          expect(response.status).to eq(200)
        end
        context "ログインしてから14日以内" do
          around do |e|
            travel_to('2021-2-29 10:00'.to_time){ e.run }
          end
          it "14日以内であればログアウトできる" do
            travel 13.day
            delete(destroy_api_v1_user_session_path,headers:@params[:headers])
            expect(response.status).to eq(200)
          end
        end
      end
    end
    context "ログアウトに失敗する" do
      it "headerが空"do
        delete(destroy_api_v1_user_session_path,headers:{})
        res = JSON.parse(response.body)
        expect(res['errors']).to include("ユーザーが見つからないか、ログインしていません。")
        expect(response.status).to eq(404)
      end
      it "ログインしていないユーザでログアウトを行う" do
        delete(destroy_api_v1_user_session_path,headers:{})
        res = JSON.parse(response.body)
        expect(res['errors']).to include("ユーザーが見つからないか、ログインしていません。")
        expect(response.status).to eq(404)
      end
      it "tokenの有効期限が超過している" do
        delete(destroy_api_v1_user_session_path,headers:{})
        res = JSON.parse(response.body)
      end
      context "ログインしてから14日後" do
        around do |e|
          travel_to('2021-2-29 10:00'.to_time){ e.run }
        end
        it "14日を過ぎるとログアウトできない" do
          travel 14.day
          delete(destroy_api_v1_user_session_path,headers:@params[:headers])
          res = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(res['errors']).to include("ユーザーが見つからないか、ログインしていません。")
        end
      end
    end
  end
end

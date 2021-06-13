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
end

require 'rails_helper'
RSpec.describe "DirectUploads", type: :request do
  def file_upload_json(file_path)
    file_data = File.read(file_path)
    byte_size = file_data.bytes.size
    checksum = Base64.strict_encode64(Digest::MD5.digest(file_data))
    content_type = Mime[File.extname(file_path).split('.').last].to_s
    {io:file_fixture("sample2.jpeg").open,filename: "sample2.jpeg",byte_size:byte_size,checksum:checksum,content_type:content_type,meta_data:{}}
  end
  let (:user){FactoryBot.create(:other)}
  describe "画像をダイレクトアップロード" do
    describe "POST  /rails/active_storage/direct_uploads" do
      context "アップロードに成功"do
        it "ステータスコード 200が返ってくる" do
          blob=file_upload_json('spec/fixtures/files/sample2.jpeg')
          post(rails_active_storage_direct_uploads_path,params:{blob:blob})
          expect(response.status).to eq 200
          res=JSON.parse(response.body)
          file= fixture_file_upload("/sample2.jpeg")
        end
        it "レスポンス値にidが存在する" do
          blob=file_upload_json('spec/fixtures/files/sample2.jpeg')
          post(rails_active_storage_direct_uploads_path,params:{blob:blob})
          expect(response.status).to eq 200
          res=JSON.parse(response.body)
          expect(res).to have_key('id')
        end
        it "ActiveStorage::Blobのレコード数が増える" do
          blob=file_upload_json('spec/fixtures/files/sample2.jpeg')
          expect{post(rails_active_storage_direct_uploads_path,params:{blob:blob})}.to change(ActiveStorage::Blob, :count).from(0).to(1)
        end
      end
      context "アップロードに失敗" do
        it "アップロードする画像の指定が無い" do
          blob=file_upload_json('spec/fixtures/files/sample2.jpeg')
          begin
            post(rails_active_storage_direct_uploads_path,params:{blob:""})
          rescue => e
            expect(e.class).to eq ActionController::ParameterMissing
          end
        end
        it "blobに不備がある" do
          blob=file_upload_json('spec/fixtures/files/sample2.jpeg')
          begin
            post(rails_active_storage_direct_uploads_path,params:{blob:blob.merge(filename:nil)})
          rescue => e
            expect(e.class).to eq ActiveRecord::NotNullViolation
          end
        end
        it "ActiveStorage::Blobが増えない" do
          begin
            post(rails_active_storage_direct_uploads_path,params:{blob:blob.merge(filename:nil)})
          rescue => e
            expect(ActiveStorage::Blob.all.length).to eq 0
          end
        end
      end
    end
  end
  describe "画像を更新する" do
    describe "PUT /rails/active_storage/direct_uploads" do
    before do
      blob=file_upload_json('spec/fixtures/files/sample2.jpeg')
      post(rails_active_storage_direct_uploads_path,params:{blob:blob})
      res=JSON.parse(response.body)
      direct_upload=res['direct_upload']
      get(direct_upload['url']+"/"+res["filename"],headers:direct_upload['header'])
      @blob_id=res['id']
      @path =Rails.root.join 'spec', 'fixtures', "files",'sample2.jpeg'
      @blob=ActiveStorage::Blob.find(@blob_id)
    end
      context "更新に成功" do
        it "ステータスコード200が返ってくる。" do
          ActiveStorage::Blob.service.upload(@blob.key,@path.open)
          put(rails_active_storage_direct_uploads_path,params:{blob:{id:@blob_id},user_id:user.id})
          expect(response.status).to eq 200
        end
        it "imageUrlがレスポンス値として返ってくる" do
          ActiveStorage::Blob.service.upload(@blob.key,@path.open)
          put(rails_active_storage_direct_uploads_path,params:{blob:{id:@blob_id},user_id:user.id})
          res = JSON.parse(response.body)
          expect(res).to have_key("imageUrl")
        end
      end
      context "更新に失敗" do
        it "ストレージに画像ファイルが存在しない" do
          begin
          put(rails_active_storage_direct_uploads_path,params:{blob:{id:@blob_id},user_id:user.id})
          rescue => e
            expect(e.class).to eq  ActiveStorage::FileNotFoundError
          end
        end
        it "ユーザが見つからない" do
          begin
            put(rails_active_storage_direct_uploads_path,params:{blob:{id:@blob_id},user_id:nil})
          rescue => e
            expect(e.to_s).to eq  "Couldn't find User without an ID"
          end
        end
        it "blob_idがnil" do
          begin
            ActiveStorage::Blob.service.upload(@blob.key,@path.open)
            put(rails_active_storage_direct_uploads_path,params:{blob:{id:nil},user_id:user.id})
          rescue => e
            expect(e.to_s).to eq  "Couldn't find ActiveStorage::Blob without an ID"
          end
        end
      end
    end
  end
  describe "画像削除" do
    before do
      blob=fixture_file_upload("spec/fixtures/files/sample2.jpeg")
      user.image.attach(blob)
      user.avatar=url_for(user.image.blob)
    end
    describe "DELETE /rails/active_storage/direct_uploads" do
      subject{ blob=file_upload_json('spec/fixtures/files/sample2.jpeg')}
      context "削除に成功" do
        it "ステータスコード 200が返ってくる" do
          blob=subject
          delete(rails_active_storage_direct_uploads_path,params:{id:user.id})
          expect(response.status).to eq 200
        end
        it "avatar(url)が空白になる" do
          blob=subject
          delete(rails_active_storage_direct_uploads_path,params:{id:user.id})
          user.reload
          expect(user.avatar).to eq ""
        end
        it "ActiveStorage::Blobのレコード数が減る" do
          blob=subject
          expect{ delete(rails_active_storage_direct_uploads_path,params:{id:user.id})}.to change(ActiveStorage::Blob, :count).from(1).to(0)
        end
      end
      context "削除に失敗" do
        it "ユーザが存在しない" do
          blob=subject
          begin
            delete(rails_active_storage_direct_uploads_path,params:{id:nil})
          rescue => e
            expect(e.to_s).to eq  "Couldn't find User without an ID"
          end
        end
        it "ActiveStorage::Blobのレコード数が変わらない" do
          blob=subject
          begin
            delete(rails_active_storage_direct_uploads_path,params:{id:nil})
          rescue => e
            expect(ActiveStorage::Blob.all.length).to eq 1
          end
        end
      end
    end
  end
end

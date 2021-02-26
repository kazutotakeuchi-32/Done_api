class DirectUploadsController < ActiveStorage::DirectUploadsController
  skip_before_action :verify_authenticity_token
  def create
    blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args)
    render json: direct_uploads_json(blob)
  end
  def update
    user=User.find(params[:user_id])
    blob=ActiveStorage::Blob.find(params[:blob][:id])
    user.image.attach(blob)
    render json: {imageUrl:url_for(user.image_blob)}
  end
  def destroy
    user=User.find(params[:id])
    user.image.pupurge
    user.avatar = ""
    user.save
    render json: {stauts: 200}
  end
  private
    def direct_uploads_json(blob)
      blob.as_json(root:false,methods: :signed_id).merge(service_url:url_for(blob)).merge(direct_upload:{
        url: blob.service_url_for_direct_upload,
        headers: blob.service_headers_for_direct_upload
      })
    end
 end

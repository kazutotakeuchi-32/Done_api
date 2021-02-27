class  Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :authenticate_api_v1_admin!,only: [:destroy]
  def destroy
      user = User.find(params[:id])
      user.destroy
      render json: {}
  end
end

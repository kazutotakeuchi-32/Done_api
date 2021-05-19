class Api::V1::LikesController < ApplicationController
  before_action :authenticate_api_v1_user! ,except: [:destroy, :create]
  before_action :set_other_user
  before_action :set_date
  before_action :set_like_type

  def create
    likeing_contents,model=@other_user.likeing_type(@type,@date)
    Like.likeing_saves(likeing_contents,model,current_api_v1_user)
    render json:{
      data:{
        message:"OK"
      }
    },status:200
  end

  def destroy
    likeing_contents,model=current_api_v1_user.unlike_type(@type,@other_user,@date)
    Like.likeing_destroys(likeing_contents,model)
    render json:{
      data:{
        message:"OK"
      }
    },status:200
  end

  private
    def set_other_user
      @other_user = User.find(params[:other_user])
    end

    def set_date
      @date = params[:date].split("/")
    end

    def set_like_type
      @type = params[:type]
    end

end

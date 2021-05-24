class Api::V1::RelationshipsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_other_user,only: :create

  def create
    return if current_api_v1_user.following?(@other_user)
    follow=current_api_v1_user.follow(@other_user)
    if follow.save
      render json: {
        data:{
          message:"OK",
          followings:current_api_v1_user.following_ids,
          followers: current_api_v1_user.follower_ids,
        }
       },status:200
    else
      render json:{
        data:{
          followings:current_api_v1_user.following_ids,
          followers: current_api_v1_user.follower_ids,
      }},status:401
    end
  end

  def destroy
    @other_user = User.find(params[:id])
    if current_api_v1_user.following?(@other_user)
      current_api_v1_user.unfollow(@other_user)
      render json: {
        data:{
          message:"OK",
          followings:current_api_v1_user.following_ids,
          followers: current_api_v1_user.follower_ids,
        }
       },status:200
    else
      render json: {
        data:{
          message:"フォローされていません",
          followings:current_api_v1_user.following_ids,
          followers: current_api_v1_user.follower_ids,
        }
       },status:200
    end
  end

  private
    def set_other_user()
      @other_user =User.find_by(id:params[:follow_id])
    end
end

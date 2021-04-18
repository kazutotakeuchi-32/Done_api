class Api::V1::DraftLearnsController < ApplicationController
  before_action :authenticate_api_v1_user!
  def index
    draft_learn = prams[:sort]=="ASC"?  current_api_v1_user.draft_learns.order(created_at: "ASC") : current_api_v1_user.draft_learns
    render json:{
      data:{
        data:draft_learn
      }
    },status:200
  end
  def show
    draft_learn = DraftLearn.find(params[:id])
    render json:{
      data:{
        data:draft_learn
      }
    },status:200
  end
  def create
     draft_learn = DraftLearn.new(draft_learn_params)
     if draft_learn.save
        render json: {
          data:{
          message:"OK"
          }
         },status:200
      else
        render json:{data:{}},status:401
     end
  end
  private
    def draft_learn_params
      params.require(:draft_learn).permit(:title,:content,:time,:subject).merge(user_id:current_api_v1_user.id)
    end
end

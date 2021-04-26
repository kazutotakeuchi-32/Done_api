class Api::V1::LearnsController < ApplicationController
  before_action :authenticate_api_v1_user!
  def index
    learn = params[:sort]=="ASC"?  current_api_v1_user.learns.order(created_at: "ASC") : current_api_v1_user.learns
    render json:{
      data:{
        data:learn
      }
    },status:200
  end
  def show
    learn = Learn.find(params[:id])
    render json:{
      data:{
        data:learn
      }
    },status:200
  end
  def create
     learn = Learn.new(learn_params)
     if learn.save
        render json: {
          data:{
          message:"OK"
          }
         },status:200
      else
        render json:{data:{}},status:401
     end
  end

  def todays_task
    lerarns    =  current_api_v1_user.learns
    next_tasks =  lerarns.date_range(Time.now.beginning_of_day,Time.now.end_of_day)
    render json: {
      data:{
        nextTasks:{
          data:next_tasks,
          title: "#{Time.now.year}年#{Time.now.month}月#{Time.now.day}日の学習予定（本日）"
        }
      }
     },status:200
  end

  private
    def learn_params
      params.require(:learn).permit(:title,:content,:time,:subject).merge(user_id:current_api_v1_user.id,draft_learn_id:params[:draft_learn_id])
    end
end

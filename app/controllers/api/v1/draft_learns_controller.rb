class Api::V1::DraftLearnsController < ApplicationController
  before_action :authenticate_api_v1_user! ,except:[:todays_task,:past_tasks]
  def index
    draft_learn = params[:sort]=="ASC"?  current_api_v1_user.draft_learns.order(created_at: "ASC") : current_api_v1_user.draft_learns
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

  def todays_task
    user = User.find(params[:id])
    draft_learns = user.draft_learns
    # draft_learns = current_api_v1_user.draft_learns
    next_tasks=draft_learns.date_range(Time.now.beginning_of_day,Time.now.end_of_day)
    # draft_learns = User.find(1).draft_learns
    # next_tasks=draft_learns.date_range(Time.new(2021,04,17),Ti me.new(2021,04,17).end_of_day)
    render json: {
      data:{
        nextTasks:{
          data:next_tasks,
          title: "#{Time.now.year}年#{Time.now.month}月#{Time.now.day}日の学習予定（本日）"
        }
      }
     },status:200
  end

  def  past_tasks
    user = User.find(params[:id])
    draft_learns = user.draft_learns
    previous_tasks= draft_learns.where("created_at < ?",Time.now.ago(1.days).end_of_day)
    render json: {
      data:{
        previousTasks:{
          data:previous_tasks,
          title: "#{Time.now.year}年#{Time.now.month}月#{Time.now.day}日の学習予定（本日）"
        }
      }
     },status:200
  end

  private
    def draft_learn_params
      params.require(:draft_learn).permit(:title,:content,:time,:subject).merge(user_id:current_api_v1_user.id)
    end
end

class Api::V1::LearnsController < ApplicationController
  before_action :authenticate_api_v1_user!,except:[:todays_task,:past_tasks]
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
    user = User.find(params[:id])
    learns=user.learns
    # # learns    =  current_api_v1_user.learns
    next_tasks =  learns.date_range(Time.now.beginning_of_day,Time.now.end_of_day)
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
    rows = params[:rows].to_i
    learns = user.learns
    cuurent_page=params[:cuurent_page].to_i
    end_range=cuurent_page*rows
    start_range=cuurent_page-1 <=0  ? 0 : (cuurent_page-1)*rows
    previous_tasks= learns.where("created_at < ?",Time.now.ago(1.days).end_of_day)
    max_page = get_max_page(previous_tasks,rows)
    data= data=previous_tasks.order(created_at:"DESC")[start_range..(end_range-1)]
    render json: {
      data:{
        previousTasks:{
          data:data,
          title: "#{Time.now.year}年#{Time.now.month}月#{Time.now.day}日の学習予定（本日）"
        },
        maxPage:max_page,
      }
     },status:200
  end

  private
    def learn_params
      params.require(:learn).permit(:title,:content,:time,:subject).merge(user_id:current_api_v1_user.id,draft_learn_id:params[:draft_learn_id])
    end
    def get_max_page(previous_tasks,rows)
      if previous_tasks.length%rows==0
        page=previous_tasks.length/rows
      else
        page=(previous_tasks.length/rows)+1
      end
      return  page
    end
    def get_data(max_page,cuurent_page,previous_tasks,start_range,end_range)
      if max_page < cuurent_page
        data="データがありません"
      else
        data=previous_tasks.order(created_at:"DESC")[start_range..(end_range-1)]
      end
       return data
    end
end

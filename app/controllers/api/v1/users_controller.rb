class Api::V1::UsersController < ApplicationController
  before_action :set_date, only: [:show, :learn_search]
  before_action :set_user, only: [:show, :learn_search]
  def show
    learns  = @user.draft_learns
    from,to = DraftLearn.get_draft_learn_data(@type,@year,@month,@day)
    output  = DraftLearn.aggregation_data(@type,from,to,@year,@month,@day,learns)
    next_tasks  = learns.select{|l|l if l.created_at.to_s >= Date.today.to_s}.sort{|a,b| a.created_at.to_i<=>b.created_at.to_i}
    next_tasks_title = graph_title_next_format()
    previous_tasks_title = graph_title_previous_format(from,to)
    # previous_tasks = learns.select{|l|l if l.created_at.to_s < Date.today.to_s}.sort{|a,b| a.created_at.to_i<=>b.created_at.to_i}
    render json:{
      data:{
        user:@user,
        draftLearns:{
          nextTasks:{
            data:next_tasks,
            title:next_tasks_title
          },
          previousTasks:{
            data:output,
            title:previous_tasks_title
          },
        },
        learns:{
          nextTasks:{
            data:[],
            title:""
          },
          previousTasks:{
            data:[],
            title:""
          }
        }
      }
    },status:200
  end

  def learn_search
    learns  = @user.draft_learns
    from,to =   DraftLearn.get_draft_learn_data(@type,@year,@month,@day)
    data    =   learns.where("created_at >= ? and created_at <= ?",from.beginning_of_day,to.end_of_day)
    search_learn_task_title = graph_title_previous_format(from,to)
    render json:{
      data:{
        draftLearns:{
          search_tasks:{
            data:data,
            title:search_learn_task_title
          }
        },
        learns:{
            nextTasks:[],
            previousTasks:[]
          }
      }
    },status:200
  end
  private
    def set_user
      @user = User.find(params[:id])
    end
    def set_date
      @type    = params[:type]   ?  params[:type]  : "None"
      @year    = params[:year]   ?  params[:year]  : Time.now.year
      @month   = params[:month]  ?  params[:month] : Time.now.month
      @day     = params[:day]    ?  params[:day]   : @month !=Time.now.month ? 1 : Time.now.day
    end
    def graph_title_previous_format(from,to)
      from.month > to.month ?
            " #{from.year}年#{from.month}月#{from.day}日~#{to.year}年#{to.month}月#{to.day}日の学習状況"
            :
            from.day != to.day ?
              " #{from.year}年#{from.month}月#{from.day}日~#{to.month}月#{to.day}日の学習状況"
              :
              "#{from.year}年#{from.month}月#{from.day}日の学習状況"
    end
    def graph_title_next_format()
      Time.now.day == @day.to_i ?
        "#{Time.now.year}年#{Time.now.month}月#{@day}日の学習予定（本日）"
        :
        "#{Time.now.year}年#{Time.now.month}月#{@day}日の学習予定"
    end
end

# output=[]
    # (from.month..to.month).each do |m|
    #   sum=0
    #   sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(params[:year],m),Time.new(params[:year],m).end_of_month)
    #   sum_days.each do |sum_day|
    #     puts sum_day.time
    #     sum+=sum_day.time
    #   end
    #   output.push({label:"#{m}月",data:sum})
    # end
    # (from.month..to.month).each do |m|
    #   sum=0
    #   sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(params[:year],m),Time.new(params[:year],m).end_of_month)
    #   sum_days.each do |sum_day|
    #     puts sum_day.time
    #     sum+=sum_day.time
    #   end
    #   output.push({label:"&#{m}月",data:sum})
    # end
    # (from.day..to.day).each do |d|
    #   sum=0
    #   sum_days=learns.where("created_at >= ? and created_at <= ?",Time.new(params[:year],params[:month],d),Time.new(params[:year],params[:month],d).end_of_day)
    #   sum_days.each do |sum_day|
    #     puts sum_day.time
    #     sum+=sum_day.time
    #   end
    #   output.push({label:"#{params[:month]}月#{d}日",data:sum})
    # end
    #  p output

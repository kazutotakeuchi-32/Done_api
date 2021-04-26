class Api::V1::UsersController < ApplicationController
  before_action :set_date, only: [:show, :learn_search,:search]
  before_action :set_user, only: [:show, :learn_search,:search]
  before_action :set_draft_learns, only: [:show, :learn_search,:search]
  before_action :set_learns, only: [:show, :learn_search,:search]

  def show
    model_class=[{model:DraftLearn},{model:Learn}]
    draft_learn_next_tasks,draft_learn_next_tasks_title,draft_learn_previous_tasks,draft_learn_previous_tasks_title = get_learn_data(model_class[0],@draft_learns)
    learn_next_tasks,learn_next_tasks_title,learn_previous_tasks,learn_previous_tasks_title = get_learn_data(model_class[1],@learns)
    render json:{
      data:{
        user:@user,
        draftLearns:{
          nextTasks:{
            data: draft_learn_next_tasks,
            title:draft_learn_next_tasks_title
          },
          previousTasks:{
            data:draft_learn_previous_tasks,
            title:draft_learn_previous_tasks_title
          },
        },
        learns:{
          nextTasks:{
            data:learn_next_tasks,
            title:learn_next_tasks_title
          },
          previousTasks:{
            data:learn_previous_tasks,
            title:learn_previous_tasks_title
          }
        }
      }
    },status:200
  end


  def learn_search
    model_class=[{model:DraftLearn},{model:Learn}]
    draft_learn_data,draft_learn_title = search_learn_data(model_class[0],@draft_learns)
    learn_data,learn_title = search_learn_data(model_class[1],@learns)
    render json:{
      data:{
        draftLearns:{
          search_tasks:{
            data:draft_learn_data,
            title:draft_learn_title
          }
        },
      learns:{
            search_tasks:{
              data:learn_data,
              title:learn_title
            }
        }
      }
    },status:200
  end

  def search
    model_class=[{model:DraftLearn},{model:Learn}]
    draft_learn_next_tasks,draft_learn_next_tasks_title,draft_learn_previous_tasks,draft_learn_previous_tasks_title = get_learn_data(model_class[0],@draft_learns)
    learn_next_tasks,learn_next_tasks_title,learn_previous_tasks,learn_previous_tasks_title = get_learn_data(model_class[1],@learns)
    render json:{
      data:{
        draftLearns:{
          search_tasks:{
            data:draft_learn_previous_tasks,
            title:draft_learn_previous_tasks_title
          }
        },
      learns:{
            search_tasks:{
              data:learn_previous_tasks,
              title:learn_previous_tasks_title
            }
        }
      }
    },status:200
  end


  private

    def set_user
      @user = User.find_by(id:params[:id])
    end

    def set_date
      @type    = params[:type]   ?  params[:type]  : "None"
      @year    = params[:year]   ?  params[:year]  : Time.now.year
      @month   = params[:month]  ?  params[:month] : Time.now.month
      @day     = params[:day]    ?  params[:day]   : @month !=Time.now.month ? 1 : Time.now.day
    end

    def set_draft_learns
      @draft_learns = @user.draft_learns
    end

    def set_learns
      @learns = @user.learns
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
        "#{Time.now.year}年#{Time.now.month}月#{Time.now.day}日の学習予定（本日）"
        :
        "#{Time.now.year}年#{Time.now.month}月#{Time.now.day}日の学習予定"
    end

    def get_learn_data(model_class,learns)
      from,to = model_class[:model].get_draft_learn_data(@type,@year,@month,@day)
      previous_tasks  = model_class[:model].aggregation_data(@type,from,to,@year,@month,@day,learns)
      next_tasks  = learns.select{|l|l if l.created_at.to_s >= Date.today.to_s}.sort{|a,b| a.created_at.to_i<=>b.created_at.to_i}
      next_tasks_title = graph_title_next_format()
      previous_tasks_title = graph_title_previous_format(from,to)
      return next_tasks,next_tasks_title,previous_tasks,previous_tasks_title
    end

   def search_learn_data(model_class,learns)
      from,to =   model_class[:model].get_draft_learn_data(@type,@year,@month,@day)
      data    =   learns.date_range(from.beginning_of_day,to.end_of_day)
      search_learn_task_title = graph_title_previous_format(from,to)
      return data,search_learn_task_title
   end

end

# previous_tasks = learns.select{|l|l if l.created_at.to_s < Date.today.to_s}.sort{|a,b| a.created_at.to_i<=>b.created_at.to_i}
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

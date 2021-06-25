class Api::V1::UsersController < ApplicationController
  before_action :set_date, only: [:show, :pie_graph,:bar_graph]
  before_action :set_user, only: [:show, :pie_graph,:bar_graph,:follows,:followers,:time_line,:mutual_following]
  before_action :set_draft_learns, only: [:show, :pie_graph,:bar_graph]
  before_action :set_learns, only: [:show, :pie_graph,:bar_graph]
  def show
    return render json:{data:{},errors:["ユーザが存在しません"]},status:401 if !@user
    model_class=[{model:DraftLearn},{model:Learn}]
    draft_learn_next_tasks,draft_learn_next_tasks_title,draft_learn_previous_tasks,draft_learn_previous_tasks_title = get_learn_data(model_class[0],@draft_learns)
    learn_next_tasks,learn_next_tasks_title,learn_previous_tasks,learn_previous_tasks_title = get_learn_data(model_class[1],@learns)
    render json:{
      data:{
        user:@user,
        followings:@user.following_ids,
        followers:@user.follower_ids,
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

  def search
    return render json:{data:{users:[] }} if params[:search].blank? || params[:search]==nil
    # users = User.where("name LIKE ? ","%#{params[:search]}%")
    users = User.where("name LIKE ? AND id!=?","%#{params[:search]}%",params[:id])
    render json:{
      data:{
       users:users,
       message:users.length==0 ? "検索結果がありません。": ""
      }
    }
  end

  def pie_graph
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

  def bar_graph
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

  def follows
    followings=@user.followings
    render json:{
      data:{
        followings:followings,
        message:followings.length==0 ? "フォローしているユーザがいません。" : ""
      }
    }
  end

  def followers
   followers = @user.followers
   render json:{
     data:{
       followers:followers,
       message:followers.length==0? "フォロワーがいません" : ""
     }
   }
  end

  def mutual_following
    mutual_following = @user.followings.select{|other_user|@user.mutual_following?(other_user)}
    if params[:search]
      mutual_following=mutual_following.select{|other_user|other_user.name.include?("#{params[:search]}")}
      # mutual_following = mutual_following_filter.length==0 ? mutual_following : mutual_following_filter
    end
    message=mutual_following.length==0 ? "検索結果がありません。": ""
    render json:{
      data:{
        users:mutual_following,
        message:message
      }
    }
  end



  def time_line
    cuurent_page=params[:cuurent_page].to_i
    users,time_line = aggregation_type(params[:type])
    output=User.time_line(time_line,users)
    max_page = get_max_page(output)
    end_range   = (cuurent_page*30-1)
    start_range = cuurent_page-1 <=0  ? 0 : (cuurent_page-1)*30
    render json:{
      data:{
        timeLine:output[start_range..end_range],
        maxPage:max_page
      }
    }
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
      return if !@user
      @draft_learns = @user.draft_learns
    end

    def set_learns
      return if !@user
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
      from,to = model_class[:model].get_start_and_end_time(@type,@year,@month,@day)
      previous_tasks  = model_class[:model].aggregation_data(@type,from,to,@year,@month,@day,learns)
      next_tasks  = learns.select{|l|l if l.created_at.to_s >= Date.today.to_s}.sort{|a,b| a.created_at.to_i<=>b.created_at.to_i}
      next_tasks_title = graph_title_next_format()
      previous_tasks_title = graph_title_previous_format(from,to)
      return next_tasks,next_tasks_title,previous_tasks,previous_tasks_title
    end

   def search_learn_data(model_class,learns)
      from,to =   model_class[:model].get_start_and_end_time(@type,@year,@month,@day)
      data    =   learns.date_range(from.beginning_of_day,to.end_of_day)
      search_learn_task_title = graph_title_previous_format(from,to)
      return data,search_learn_task_title
   end

   def get_time_line(following_ids)
    qurey = following_ids.map{|id|" OR user_id=#{id}"}.join
    time_line=DraftLearn.friends_data_with_me(qurey,@user)+Learn.friends_data_with_me(qurey,@user)
    time_line=time_line.group_by{|t| t.created_at.to_date }.values
    return time_line
   end

   def get_max_page(output)
    if output.length%30==0
      max_page=output.length/30
    else
      max_page=output.length/30+1
    end
   end

   def aggregation_type(type)
    case type
      when "BASIC"
        # タイムライン
        following_ids=@user.following_ids
        time_line = get_time_line(following_ids)
        users=@user.combine_with_friends
      when "MYONLY"
        # ユーザの投稿のみ
        time_line = get_time_line([@user.id])
        users=[@user]
      when "LIKE"
        # いいねした日付の投稿を取得する
        # following_ids=@user.following_ids
        likeing_contents = @user.draft_learn_likes+@user.learn_likes
        users=@user.combine_with_friends
        time_line=likeing_contents.group_by{|t| t.created_at.to_date }.values
      else
    end
    return users,time_line
   end
end

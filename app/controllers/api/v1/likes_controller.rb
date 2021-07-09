class Api::V1::LikesController < ApplicationController
  before_action :authenticate_api_v1_user! ,except: [:destroy, :create]
  before_action :set_other_user
  before_action :set_date
  before_action :set_like_type

  def create
    likeing_contents,model=@other_user.likeing_type(@type,@date)
    return render json:{
      data:{
        message:"投稿が存在しません"
      }
    },status:401 if likeing_contents==[]

    Like.likeing_saves(likeing_contents,model,current_api_v1_user)
    item_id=likeing_contents[0][:draft_learn_id]? :learn_id : :draft_learn_id
    Notification.create(
      sender_id:current_api_v1_user.id,
      kind:"いいね",
      receiver_id:@other_user.id,
      item_id=> likeing_contents[0].id,
    )
    # いいねされたら、このタイミングで通知を作成。
    render json:{
      data:{
        message:"OK"
      }
    },status:200
  end

  def destroy
    likeing_contents,model=current_api_v1_user.unlike_type(@type,@other_user,@date)
    return render json:{
      data:{
        message:"投稿が存在しません"
      }
    },status:401 if likeing_contents==[]
    Like.likeing_destroys(likeing_contents,model)
    item_id=likeing_contents[0][:draft_learn_id]? :learn_id : :draft_learn_id
     # いいねを解除されたら通知を削除。
    notification=Notification.find_by(item_id=>likeing_contents[0].id)
    notification.destroy
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

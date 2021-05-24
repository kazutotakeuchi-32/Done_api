class Api::V1::MessagesController < ApplicationController
  def create
    message=Message.new(message_params)
    if message.save
      render json:{data:{message:message}},status:200
    else
      render json:{data:{message:"投稿に失敗しました。"}},status:401
    end
  end

  private
    def message_params
      params.require(:message).permit(:message).merge(user_id:params[:user_id],room_id:params[:room_id])
    end

end

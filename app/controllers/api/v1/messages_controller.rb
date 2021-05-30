class Api::V1::MessagesController < ApplicationController
  def create
    # binding.pry
    message=Message.new(message_params)
    # params[:room_id]
    if message.save
      room = Room.find(message.room_id)
      MessagesChannel.broadcast_to room, message
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

class Api::V1::MessagesController < ApplicationController
  def create
    message=Message.new(message_params)
    if message.save
      room = Room.find(message.room_id)
      read=Read.create(message_id:message.id,user_id:params[:user_id])
      MessagesChannel.broadcast_to room, {message:message,read:read,name:"未読"}
      ActionCable.server.broadcast("room_channel",{room:room,message:message,read:read},)
      render json:{data:{message:message,read:read}},status:200
    else
      render json:{data:{message:"投稿に失敗しました。"}},status:401
    end
  end

  private

    def message_params
      params.require(:message).permit(:message).merge(user_id:params[:user_id],room_id:params[:room_id])
    end

end

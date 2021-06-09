class Api::V1::MessagesController < ApplicationController
  def create
    message=Message.new(message_params)
    if message.save
      entry = Entry.find_by(room_id:message.room_id)
      room = Room.find(message.room_id)
      read=Read.create(message_id:message.id,user_id:params[:user_id],room_id:message.room_id)
      # 相手からDMされたら通知を作成する。
      other_user=room.entry_to_users.select{|us|us.id != params[:user_id].to_i}[0]
      Notification.create(
        sender_id:params[:user_id],
        kind:"DM",
        receiver_id:other_user.id,
        message_id:message.id
      )
      MessagesChannel.broadcast_to room, {message:message,read:read,name:"未読"}
      ActionCable.server.broadcast("room_channel",{room:entry,message:message,read:read})
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

class Api::V1::ReadsController < ApplicationController
  def update
   read = Read.find(params[:id])
   if read.update(read_params(read.message.id))
    # 他のユーザのメッセージを受け取ったら、already_readをtrueに変更する。
    room=Room.find(params[:room_id])
    MessagesChannel.broadcast_to room,{message:read.message,read:read,name:"既読"}
    render json:{data:{message:"OK"}},status:200
   else
    render json:{data:{message:"更新に失敗しました。"}},status:401
   end
  end
  private
    def read_params(message_id)
      params.require(:room).permit(:already_read).merge(user_id:params[:user_id],message_id:message_id)
    end
end

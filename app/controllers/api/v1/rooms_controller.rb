class Api::V1::RoomsController < ApplicationController

  def index
    user=User.find(params[:user_id])
    entries=user.entries
    rooms=[]
    entries.each do |e|
      other_user=Entry.where(room_id:e.room_id).map{|c|c.user}.select{|us|us.id != user.id}[0]
      un_read_count=Read.where(user_id:other_user.id,room_id:e.room_id,already_read:false)
      lastMessages=Message.where(room_id:e.room_id).last
      lastMessages=lastMessages ? lastMessages : {message:"まだトーク履歴がありません。",created_at:e.created_at}
      rooms.push({room:e,user:other_user,lastMessages:lastMessages,unReadCount:un_read_count})
    end
    # ActionCable.server.broadcast("room_channel",{rooms:rooms})
    rooms.sort!{|a,b|b[:lastMessages][:created_at]<=>a[:lastMessages][:created_at]}
    render json:{
      data:{
        rooms:rooms
      }
    },status:200
    # ActionCable.server.broadcast("room_channel",{rooms:rooms})
  end


  def show
    room = Room.find(params[:id])
    user=room.entry_to_users.select{|user|user.id != User.find(params[:user_id]).id}[0]
    messages = room.messages
    # このタイミングで未読なメッセージがあった場合、既読に変更する。
    reads=[]
    messages.each do |message|
      read=message.read
      read.update(already_read:true) if user.id == read.user_id && !read.already_read
      reads.push(read)
    end
    MessagesChannel.broadcast_to room,{message:{},reads:reads,name:"入室"}
    render json:{
      data:{
        room:room,
        user:user,
        messages:messages,
        reads:reads
      }
    },status:200
  end

end

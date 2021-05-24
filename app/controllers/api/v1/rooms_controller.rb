class Api::V1::RoomsController < ApplicationController

  def index
    user=User.find(params[:user_id])
    entries=user.entries
    rooms=[]
    entries.each do |e|
      other_user=Entry.where(room_id:e.room_id).map{|c|c.user}.select{|us|us.id != user.id}[0]
      lastMessages=Message.where(room_id:e.room_id).last
      lastMessages=lastMessages ? lastMessages : {message:"まだトーク履歴がありません。",created_at:e.created_at}
      rooms.push({room:e,user:other_user,lastMessages:lastMessages})
    end
    rooms.sort!{|a,b|b[:lastMessages][:created_at]<=>a[:lastMessages][:created_at]}
    render json:{
      data:{
        rooms:rooms
      }
    },status:200
  end

  def show
    room = Room.find(params[:id])
    user=room.entry_to_users.select{|user|user.id != User.find(params[:user_id]).id}[0]
    messages = room.messages
    render json:{
      data:{
        room:room,
        user:user,
        messages:messages
      }
    },status:200
  end

end

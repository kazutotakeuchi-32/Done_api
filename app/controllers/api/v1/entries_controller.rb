class Api::V1::EntriesController < ApplicationController
  def create
    user=User.find(params[:user_id])
    other_user=User.find(params[:other_user])
    return render json:{
      data:{
        message:"相互フォローしていないのでチャットルームを作成する事ができません",
      }
    },status:401  if !user.mutual_following?(other_user)

    if Entry.entry_not_exist?(user,other_user)
      room=Room.create()
      [
        {user_id:user.id,room_id:room.id},
        {user_id:other_user.id,room_id:room.id}
      ].each do |param|
        entry=Entry.new(param)
        entry.save
      end
      render json:{
        data:{
          room:room.id,
          message:"OK"
        }
      },status:200
    else
      room=Entry.get_room(user,other_user)
      render json:{
        data:{
          message:"チャットルームは既に存在します。",
          room:room
        }
      },status:200
    end
  end
end

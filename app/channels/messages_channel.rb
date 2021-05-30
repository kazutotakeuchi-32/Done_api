class MessagesChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room_id])
    stream_for room
    stream_for current_user.id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end


end

class Api::V1::NotificationsController < ApplicationController
  def index
    notifications=Notification.where(receiver_id:params[:user_id],checked:false)
    data=[]
    notifications.each do |notification|
      message= notification.kind == "DM" ? notification.message : ""
      data.push({
        id:notification.id,
        receiver:notification.receiver,
        sender: notification.sender,
        message:message,
        kind:notification.kind
      })
    end
    render json:{data: data},status:200
  end

  def update
    notification=Notification.find(params[:id])
    if notification.update(checked:true)
      render json:{message:"OK"},status:200
    else
      render json:{message:"更新に失敗しました。"},status:401
    end
  end


end

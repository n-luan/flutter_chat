class RoomChannel < ApplicationCable::Channel
  delegate :current_user, to: :connection, prefix: nil

  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
  end

  def speak data
    BroadcastMessageService.new(user: current_user, data: data).perform
  end
end

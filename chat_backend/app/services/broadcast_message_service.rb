class BroadcastMessageService
  attr_reader :user, :data
  def initialize args
    @user = args[:user]
    @data = args[:data]
  end

  def perform
    message = user.messages.create text: data["message"]

    ActionCable.server.broadcast "room_channel", message: {
      id: message.id,
      user: {id: user.id, name: user.name},
      text: data["message"]
    }

    SendNotificationJob.perform_later message.id
  end
end

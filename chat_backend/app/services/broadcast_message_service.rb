class BroadcastMessageService
  attr_reader :user, :data
  def initialize args
    @user = args[:user]
    @data = args[:data]
  end

  def perform
    ActionCable.server.broadcast "room_channel", message: {
      user: {id: user.id, name: user.name},
      text: data["message"]
    }
    user.messages.create text: data["message"]
  end
end

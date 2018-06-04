class MockMessage
  def perform
    current_user = User.all.sample
    text = Faker::LeagueOfLegends.quote
    message = current_user.messages.create text: text
    ActionCable.server.broadcast "room_channel", message: {
      id: message.id,
      user: {id: current_user.id, name: current_user.name},
      text: text
    }

    SendNotificationJob.perform_later message.id
  end
end

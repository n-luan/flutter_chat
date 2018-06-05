class MockMessage
  def perform
    current_user = User.all.sample
    text = Faker::LeagueOfLegends.quote
    message = current_user.messages.create text: text
    ActionCable.server.broadcast "room_channel", message: MessageSerializer.new(message).to_h

    SendNotificationJob.perform_later message.id
  end
end

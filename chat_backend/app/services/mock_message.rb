class MockMessage
  def perform
    current_user = User.all.sample
    text = Faker::LeagueOfLegends.quote
    ActionCable.server.broadcast "room_channel", message: {
      user: {id: current_user.id, name: current_user.name},
      text: text
    }
    current_user.messages.create text: text
  end
end

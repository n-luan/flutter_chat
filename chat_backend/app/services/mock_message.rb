class MockMessage
  def perform
    current_user = User.all.sample
    ActionCable.server.broadcast "room_channel", message: {
      user: {id: current_user.id, name: current_user.name},
      text: Faker::LeagueOfLegends.quote
    }
  end
end

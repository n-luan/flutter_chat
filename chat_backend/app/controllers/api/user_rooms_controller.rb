class Api::UserRoomsController < Api::AuthController
  def update
    current_user.user_room.update read_at: Time.zone.now
    render status: :ok
  end
end

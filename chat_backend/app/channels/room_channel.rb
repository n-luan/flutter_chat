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

  def mark_seen data
    # conversation_user_profile = current_user_profile.conversation_user_profiles
    #   .find_by conversation_id: data["conversation_id"]
    # conversation_user_profile.update read_at: Time.zone.now if conversation_user_profile
  end
end

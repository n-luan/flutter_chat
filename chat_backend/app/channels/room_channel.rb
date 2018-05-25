class RoomChannel < ApplicationCable::Channel
  delegate :current_user, to: :connection, prefix: nil

  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
  end

  def speak data
    ActionCable.server.broadcast "room_channel", message: {
      user: {id: current_user.id, name: current_user.name},
      text: data["message"]
    }

    # logger.info "user: #{current_user_profile.id}-#{current_user_profile.name}, token: #{token}, ip: #{ip}, method: speak"
    # Chat::BroadcastMessageService.new(data, current_user_profile).perform
  # rescue ActiveRecord::RecordInvalid => e
  #   ActionCable.server.broadcast channel_name(current_user_profile.id), content: e.record.errors.full_messages
  # rescue APIError::Client::AccessDeny => e
  #   ActionCable.server.broadcast channel_name(current_user_profile.id), Api::V1::Errors::ApiErrorsSerializer.new(e)
  end

  def mark_seen data
    # conversation_user_profile = current_user_profile.conversation_user_profiles
    #   .find_by conversation_id: data["conversation_id"]
    # conversation_user_profile.update read_at: Time.zone.now if conversation_user_profile
  end
end

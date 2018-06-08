class SendNotificationJob < ApplicationJob
  require 'fcm'
  attr_reader :fcm

  queue_as :default

  def fcm
    @fcm ||= FCM.new(ENV['FCM_SERVER_KEY'] || 'AAAAZRdrMDs:APA91bGg8Q0z4bmdnHPPt696_wFPgg-E9yXQlEIw3KWzRwPUAN87lufxS1xlMtPVfA__nVfaOGU_J7XAv1ZfHODVOldVU2Ki03ybdp5v9NyqxtE0LVvlGg6BuvXwEctxRGD2TRoXM1W-')
  end

  def perform(message_id)
    message = Message.find message_id

    User.includes(:device_tokens).all.each do |user|
      options = { data: {
        action: :chat,
        unread_count: user.unread_count,
        id: message.id,
        text: message.text,
        created_at: message.created_at.to_s,
        user: { id: message.user_id, name: message.user_name }
      } }
      device_tokens = user.device_tokens.pluck(:token)
      puts "User #{user.id}: Devices: #{device_tokens.count} Unread: #{user.unread_count}"
      fcm.send device_tokens, options
    end
  end
end

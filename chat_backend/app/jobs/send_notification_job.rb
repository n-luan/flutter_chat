class SendNotificationJob < ApplicationJob
  require 'fcm'
  attr_reader :fcm

  queue_as :default

  def fcm
    @fcm ||= FCM.new(ENV['FCM_SERVER_KEY'] || 'AAAAZRdrMDs:APA91bGg8Q0z4bmdnHPPt696_wFPgg-E9yXQlEIw3KWzRwPUAN87lufxS1xlMtPVfA__nVfaOGU_J7XAv1ZfHODVOldVU2Ki03ybdp5v9NyqxtE0LVvlGg6BuvXwEctxRGD2TRoXM1W-')
  end

  def perform(message_id)
    message = Message.find message_id

    options = { data: {
      action: :chat,
      id: message.id,
      user: { id: message.user_id, name: message.user_name },
      text: message.text
    } }

    device_tokens = DeviceToken.pluck(:token)
    fcm.send device_tokens, options
  end
end

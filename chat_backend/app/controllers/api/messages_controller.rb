class Api::MessagesController < Api::AuthController
  def index
    messages = Message.includes(:user).order(created_at: :desc).page(params[:page]).per 20
    current_user.user_room.update read_at: Time.zone.now
    render json: MessageListSerializer.new(messages: messages).generate
  end
end

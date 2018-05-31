class Api::MessagesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  def index
    messages = Message.includes(:user).order(created_at: :desc).page(params[:page]).per 20
    render json: MessageListSerializer.new(messages: messages).generate
  end
end

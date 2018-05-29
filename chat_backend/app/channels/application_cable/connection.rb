module ApplicationCable
  class Connection < ActionCable::Connection::Base

    attr_reader :access_token, :current_user
    identified_by :token, :uid, :client_id

    def connect
      @uid = request.env["HTTP_UID"]
      @token = request.env["HTTP_ACCESS_TOKEN"]
      @client_id = request.env["HTTP_CLIENT_ID"]
      find_verified_user
    end

    private
    def find_verified_user
      user = User.find_by uid: uid
      if user && user.valid_token?(@token, @client_id)
        @current_user = user
      else
        reject_unauthorized_connection
      end
    end
  end
end

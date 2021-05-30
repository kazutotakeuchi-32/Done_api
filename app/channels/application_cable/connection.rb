module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    include ActionController::HttpAuthentication::Token::ControllerMethods
    identified_by :current_user

    def connect
      client = request.query_parameters["client"]
      uid = request.query_parameters["uid"]
      access_token = request.query_parameters["token"]
      self.current_user = find_verified_user(access_token,uid,client)
    end

    private
      def find_verified_user(token,uid,client_id) # this checks whether a user is authenticated with devise
        user = User.find_by email: uid
        # http://www.rubydoc.info/gems/devise_token_auth/0.1.38/DeviseTokenAuth%2FConcerns%2FUser:valid_token%3F
        if user && user.valid_token?(token, client_id)
          user
        else
          reject_unauthorized_connection
        end
      end
  end
end

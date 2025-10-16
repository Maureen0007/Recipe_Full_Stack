class ApplicationController < ActionController::API
  before_action :authorize_request

  SECRET_KEY = Rails.application.secret_key_base.to_s

  private

  def encode_token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ").last
      begin
        JWT.decode(token, SECRET_KEY)[0]
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorize_request
    decoded = decode_token
    
    if decoded
      @current_user = User.find_by(id: decoded["user_id"])
    end
    render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
  end
end

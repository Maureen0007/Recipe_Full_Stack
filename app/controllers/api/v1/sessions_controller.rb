class Api::V1::SessionsController < ApplicationController
    skip_before_action :authorize_request, only: [:create]

    def create
        user = User.find_by(email: params[:user][:email])
        if user&.authenticate(params[:user][:password])
            token = encode_token({ user_id: user.id })
            render json: { user: user, token: token }, status: :ok
        else
            render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
    end

    def destroy
        # For JWT, logout is typically handled on the client side by deleting the token.
        render json: { message: 'Logged out successfully' }, status: :ok
    end
end

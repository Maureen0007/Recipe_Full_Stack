class Api::V1::ProfilesController < ApplicationController
  def show
    render json: {
      id: @current_user.id,
      name: @current_user.name,
      email: @current_user.email,
      avatar: @current_user.avatar
    }, status: :ok
  end

  def update
        if @current_user.update(user_params)
          if params[:avatar]
            @current_user.avatar.attach(params[:avatar])
          end
          render json: { message: "Profile updated successfully" }, status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

  private

  def user_params
    params.permit(:name, :email, :avatar)
  end
end

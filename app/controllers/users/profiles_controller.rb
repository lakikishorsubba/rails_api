class Users::ProfilesController < ApplicationController
    before_action :authenticate_user!, except: [:public]

  # GET /profile
  def show
    render json: current_user.profile_json
  end

  # PATCH/PUT /profile
  def update
    if current_user.update(profile_params)
      attach_avatar_if_present!
      render json: current_user.profile_json, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /profile
  def destroy
    current_user.avatar.purge if current_user.avatar.attached?
    render json: current_user.profile_json, status: :ok
  end

  # GET /profiles/:id (public view)
  def public
    user = User.find(params[:id])
    render json: user.profile_json
  end

  private

  def profile_params
    params.permit(:name, :bio)
  end

  def attach_avatar_if_present!
    return unless params[:avatar].present?
    current_user.avatar.attach(params[:avatar])
  end
end

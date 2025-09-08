class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def pending
    users = User.where(approved: false)
    render json: users
  end

  def approved
    user = User.find(params[:id])
    user.update!(approved: true)
    render json: { status: "approved", user: user }
  end

  private

  def authorize_admin!
    unless current_user.role == "admin"
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end
end 

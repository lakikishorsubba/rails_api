class Admin::UsersController < ApplicationController
  #before_action is a controller callback action that runs before the controller.
  #authenticate_user! is a devise helper method, 
  #before_action is a rails method that calls anotehr method :authenticate_user! 
  #  : act as a referrence to name (method).
  before_action :authenticate_user! # if no user is login redirect, else go on with the controller
  before_action :authorize_admin! # to ensure user is admin.

  def pending
    users = User.where(approved: false) 
    render json: users
  end

  def approved
    user = User.find(params[:id]) # params is strong parameter filtering hash that that rails converts json to it.
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

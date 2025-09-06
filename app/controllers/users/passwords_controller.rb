# app/controllers/users/passwords_controller.rb
class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # POST /password (send reset instructions)
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: { status: "success", message: "If your email exists, reset instructions have been sent." }, status: :ok
    else
      render json: { status: "error", errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /password (reset password)
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: { status: "success", message: "Password has been changed successfully." }, status: :ok
    else
      render json: { status: "error", errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end


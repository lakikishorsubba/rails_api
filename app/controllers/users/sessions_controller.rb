
class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :authenticate_user!
  respond_to :json
  include RackSessionsFix
 def destroy_account
    if current_user.destroy
      render json: { status: 200, message: "Account deleted successfully." }
    else
      render json: { status: 422, message: "Couldn't delete account", errors: current_user.errors.full_messages }
    end
  end

  private
  def respond_with(resource, _opts = {})
    if resource.approved?
      render json: {
        status: { 
          code: 200, message: 'Logged in successfully.',
          data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
        }}, status: :ok
    else
      render json: {status: {code: 401, message: "your account is pending admin."}}, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    end
    
    if current_user
      render json: {status: 200, message: 'Logged out successfully.'}, status: :ok
    else
      render json: {status: 401, message: "Couldn't find an active session."}, status: :unauthorized
    end
  end
end

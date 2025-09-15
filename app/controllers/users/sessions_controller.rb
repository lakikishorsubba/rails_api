class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  before_action :authenticate_user!, only: [:destroy_account]

  # Delete account
  def destroy_account
    if current_user.destroy
      render json: { status: 200, message: "Account deleted successfully." }
    else
      render json: { status: 422, message: "Couldn't delete account", errors: current_user.errors.full_messages }
    end
  end

  private
#login user if approved
 def respond_with(resource, _opts = {}) #resource is current user, _opts is options hash
  if resource.approved? 
    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  else
    render json: { status: { code: 401, message: "Your account is in pending, wait until admin approve." } }, status: :unauthorized
    end
  end

  #logout user
  def respond_to_on_destroy
    if request.headers['Authorization'].present? #check if the Authorization header is present
      #decode the JWT token using secret to find the user id(sub)
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      # Find the user based on the decoded JWT sub.
      user = User.find_by(id: jwt_payload['sub'])
    end
    # If the user is found, sign them out
    if user
      render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end

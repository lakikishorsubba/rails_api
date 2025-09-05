class ApplicationController < ActionController::API
  
     before_action :configure_permitted_parameters, if: :devise_controller?
    
     protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])

  end
   def respond_with(resource, _opts = {})
    if resource.persisted?
      token = request.env["warden-jwt_auth.token"]
      response.set_header("Authorization", "Bearer #{token}")
      render json: { status: "success", data: resource }, status: :ok
    else
      render json: { status: "error", errors: resource.errors.full_messages },
             status: :unprocessable_entity
    end
  end
  
  def respond_to_on_destroy
    head :no_content
  end
end


class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!

  respond_to :json
  include RackSessionsFix

   #check current password entered is valid
  def change_password
    unless current_user.valid_password?(params[:current_password])
      return render json: {status: "error", errors: ["current password is invalid"]}, status: :unauthorized
    end

    if current_user.update(password_params)
      render json: {status: "success", message:"password updated successfully"}
    else
      render json: {status: "error", error: current_user.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts={})
    if resource.persisted?
      if resource.approved?
        render json: {status: {code: 200, message: "signed up successfully."},data: UserSerilizer.new(resource).serializable_hash[:data][:attributes]}
      else
        render json: {status: {code: 202, message: "Registration request send"}}
      end
    else
      render json: {status: {message: "Couldnt created successfully.#{resource.errors.full_messages.to_sentence}"}},status: :unprocessable_entity
    end
  end
  #to enter new password and confirmation password.
  def password_params
    params.permit(:password, :password_confirmation)
  end

end

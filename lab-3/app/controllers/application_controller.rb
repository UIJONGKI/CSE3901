class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :configure_permitted_parameters, if: :devise_controller?

	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :phone_number, :email, :password, :current_password) }
	end
end

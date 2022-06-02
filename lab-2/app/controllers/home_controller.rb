class HomeController < ApplicationController
	before_action :authenticate_user!
	before_action :configure_permitted_parameters, if: :devise_controller?

	protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:user_type])
	end
	
	def index
	end
end

class RequestController < ApplicationController
	#This controller handles the /request page, where users can view their current user type
	#and set a request flag if they wish to change their user type, which admins can view
	#Admins will be allowed to change any user's user type from their admin page
	
	#Required to allow user type form to display (CanCanCan, Rolify gems)
	skip_before_action :verify_authenticity_token
	
	#Request page and features are restricted to registered users only.
	#This function redirects users to a descriptive error page.
    	before_action :checkLogin
    	
	private def checkLogin
		unless user_signed_in?
			flash[:user_error] = 'You must sign in to check if you have access to this feature.'
			redirect_to '/error'
		end
	end
	
	def index
		@user = User.find_by id: params[:id]
	end

	def update
		@user = User.find_by id: params[:id]
		@user.request = params[:user_type]
		@user.save
		redirect_to root_path
	end
end

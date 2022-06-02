class AdminController < ApplicationController
	#Admin panel handles features that allow admins to view a list of all users
	#and change their user type
	
	#Required to allow user forms to display (CanCanCan, Rolify gems)
	skip_before_action :verify_authenticity_token
	
	#Course-related pages are restricted to registered users only.
	#Some features are exclusive to admins
	#These functions redirect users to a descriptive error page.
    	before_action :checkLogin
    	before_action :checkAdmin
    	
	private def checkLogin
		unless user_signed_in?
			flash[:user_error] = 'You must sign in to check if you have access to this feature.'
			redirect_to '/error'
		end
	end

	private def checkAdmin
		unless current_user.has_any_role? :admin
			flash[:user_error] = 'You do not have proper permissions to access this feature.'
			redirect_to '/error'
			return false
		else
			return true
		end
	end

	#Route: GET /admin - lists all users, their roles, their request statuses and buttons used to edit them
	def index
		@users = User.all
		@role = Role.all
	end
	
	#Route: GET /admin/(user ID)/edit - brings up a form to update the user type of the ID's user
	def edit
		@user = User.find_by id: params[:id]

	end
	
	#Route: POST /admin/(user ID)/update - for updating the user type of the ID's user
	def update
		@user = User.find_by id: params[:id]
		@oldRole = Role.find_by id: @user.role_ids

		@user.remove_role @oldRole.name
		@user.add_role params[:user_type]
		@user.request = ""
		@user.save
		
		redirect_to '/admin'
	end
end

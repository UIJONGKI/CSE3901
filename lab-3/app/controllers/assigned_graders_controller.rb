class AssignedGradersController < ApplicationController
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

	def index
		@grader_assignments = GraderAssignment.all
	end

	def destroy
		@grader_assignment = GraderAssignment.find_by id: params[:id]
		@grader_assignment.destroy
		redirect_to '/assigned_graders', notice: "Course was successfully destroyed."
	end
end

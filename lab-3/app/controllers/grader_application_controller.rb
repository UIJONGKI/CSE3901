class GraderApplicationController < ApplicationController
	
=begin
	GraderApplication controller handles routes and functions related to
	the *admin* view of graders, graders' applications, and assigning them to sections.
=end
	
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
		@graders =Grader.all
	end
	
	#Borrowed from app_show controller function/view in Grader controller
	def show
		@grader = Grader.find(params[:id])
		@resume = @grader.resume
		@interest = @grader.currently_interested
		@interests = @grader.interested_courses
		@qualifications = @grader.qualified_courses
		
		@mondays = GraderAvailability.where(["grader_id = ? and weekday = ?", @grader.id, "Monday"]).order(:start)
		@tuesdays = GraderAvailability.where(["grader_id = ? and weekday = ?", @grader.id, "Tuesday"]).order(:start)
		@wednesdays = GraderAvailability.where(["grader_id = ? and weekday = ?", @grader.id, "Wednesday"]).order(:start)
		@thursdays = GraderAvailability.where(["grader_id = ? and weekday = ?", @grader.id, "Thursday"]).order(:start)
		@fridays = GraderAvailability.where(["grader_id = ? and weekday = ?", @grader.id, "Friday"]).order(:start)
	end

	def edit
		@grader = Grader.find([params[:id]])
		@courses = Course.all
		@grader_assignments = GraderAssignment.new
	end
	
	def update
		@grader = Grader.find_by id: params[:id]
		@grader_assignment = GraderAssignment.new
		@grader_assignment.grader_id = @grader.id
		@grader_assignment.section_id =  params[:section_id]
		@grader_assignment.save
		flash[:notice] = 'Grader successfully signed in to section'
		redirect_to '/notice'
	end
	
=begin
#TODO: review legacy code above
=end
	
	# From route '/assign_graders' - displays sections still in need of graders
	def needed_sections
		sections = Section.all
		
		# needing_graders array will store only sections that still need graders
		# We filter by iterating over each section, below
		
		@needing_graders = []
		sections.each do |section|
			difference = section.numGradersNeeded - section.grader_assignments.length
			
			if difference > 0
				@needing_graders.push section
			end
		end
		
		render 'assign_graders'
	end
	
	# From route '/assign_graders/:section_id/select_grader'
	# where admin initially selected a section, and now must select a grader
	def eligible_graders
		@section = Section.find(params[:section_id])
		
		# Filter out only grader profiles that have shown interested in grading this semester
		totalPool = Grader.where(["currently_interested = ?", true])
		@graders = []
		
		# Then, further filter to graders that have not already been assigned up this section
		totalPool.each do |grader|
			caughtDupe = 0
			assignments = grader.grader_assignments
			
			assignments.each do |assignment|
				if assignment.section_id == @section.id
					caughtDupe = 1
				end
			end
			
			if caughtDupe == 0
				@graders.push grader
			end
		end
		
	end
	
	# From route '/assign_graders/:section_id/select_grader/'
	# where admin initially selected a section then selected a grader
	# Redirects them to the page containing the list of current grader assignments
	def actual_assignment
		GraderAssignment.create section_id: params[:section_id], grader_id: params[:grader_id]
		#TODO: ADD CONTROL CODE FOR DUPES
		redirect_to '/assigned_graders'
	end











	
	
	
	
	

end

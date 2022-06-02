class GraderController < ApplicationController
    	
    	#Must check if user is logged in, and if user has a grader profile available
    	before_action :checkLogin
    	before_action :checkGrader, except: [:create_profile]

private def checkLogin
	unless user_signed_in?
		flash[:user_error] = 'You must sign in to check if you have access to this feature.'
		redirect_to '/error'
	end
end

private def checkGrader
	if Grader.find_by(user_id: current_user.id) == nil
		flash[:user_error] = 'An unexpected error has occured.'
		redirect_to '/error'
	end
end

#TODO: keep fleshing this out, check Annabelle's fullname method
def profile_show
	grader = Grader.find_by(user_id: current_user.id)
	@email = grader.user.email
	@interest = grader.currently_interested
	@resume = grader.resume
	@interests = grader.interested_courses
	@qualifications = grader.qualified_courses
	
	#.order function sorts from least to greatest :start time
	@mondays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Monday"]).order(:start)
	@tuesdays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Tuesday"]).order(:start)
	@wednesdays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Wednesday"]).order(:start)
	@thursdays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Thursday"]).order(:start)
	@fridays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Friday"]).order(:start)
end

#Function called when form to fill out the resume and courses completed / intersted in is opened
def app_show
	grader = Grader.find_by(user_id: current_user.id)
	@resume = grader.resume
	@interest = grader.currently_interested
	@interests = grader.interested_courses
	@qualifications = grader.qualified_courses
	render "app_edit"
end

#TODO: Add safeguards/validations	
def app_submit
	grader = Grader.find_by(user_id: current_user.id)
	
	if params[:interest] == "1"
		grader.currently_interested = true
	elsif params[:interest] == "0"
		grader.currently_interested = false
	end
	
	grader.resume = params[:resume]
	grader.interested_courses = params[:interested_courses]
	grader.qualified_courses = params[:qualified_courses]
	grader.save
	
	redirect_to '/grader/app_edit'
end

#Function called when grader opens the form to edit their schedule times
def schedule_show
	grader = Grader.find_by(user_id: current_user.id)
	@mondays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Monday"]).order(:start)
	@tuesdays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Tuesday"]).order(:start)
	@wednesdays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Wednesday"]).order(:start)
	@thursdays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Thursday"]).order(:start)
	@fridays = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, "Friday"]).order(:start)
	
	render 'schedule_edit'
	
end

# This function is called when the user decides to add a new time to their schedule
# Makes sure that the new time given does not overlap with the times they already have
# TODO: add flashes to the form
def time_add
	
	#We'll check if what was provided in the form matches these strings
	days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
	periods = ["am", "pm"]
	
	if !days.include?(params[:weekday])
		flash[:no_day] = 'Please specify a day!'
		redirect_to '/grader/schedule_edit'
		return 0
	end
	
	if !periods.include?(params[:start_period]) || !periods.include?(params[:end_period])
		flash[:no_period] = 'Please be sure to specify am/pm for both times!'
		redirect_to '/grader/schedule_edit'
		return 0
	end
	
=begin
#Next, we'll check to see if the format of the hours/minutes are correct
=end
	
	#We'll start by checking hours, must be between 1 and 12
	startHour = params[:start_hour].to_i
	endHour = params[:end_hour].to_i
	if (startHour < 1) || (startHour > 12) || (endHour < 1) || (endHour > 12)
		flash[:bad_hour] = 'Make sure you enter your hours correctly!'
		redirect_to '/grader/schedule_edit'
		return 0
	end
	
	#Set any hour 12s to 0
	if startHour == 12
		startHour = 0
	end
	if endHour == 12
		endHour = 0
	end
	
	
	#Then, we'll check minutes using regex.
	minuteRegex = /^[0-5][0-9]$/
	startMinute = params[:start_minute]
	endMinute = params[:end_minute]
	if ((startMinute =~ minuteRegex) == nil) || ((endMinute =~ minuteRegex) == nil)
		flash[:bad_minute] = 'Make sure you enter your hours correctly!'
		redirect_to '/grader/schedule_edit'
		return 0
	end
	
	#We also have to handle if minute starts with 0, and trim it off if so
	if startMinute[0,1] == "0"
		startMinute = startMinute[1,2]
	end
	if endMinute[0,1] == "0"
		endMinute = endMinute[1,2]
	end
	
	#Convert them into integers now
	startMinute = startMinute.to_i
	endMinute = endMinute.to_i
	
	
	#If we get to this point in execution, that means we can convert the times into total minutes
	startTime = (startHour * 60) + startMinute
	endTime = (endHour * 60) + endMinute
	
	#If any of the times were in pm, add an offset (720 minutes)
	if params[:start_period] == "pm"
		startTime += 720
	end
	if params[:end_period] == "pm"
		endTime += 720
	end
	
	
	#Another important check: is startTime less than endTime?
	if startTime >= endTime
		flash[:bad_time] = 'The start time must be before the end time!'
		redirect_to '/grader/schedule_edit'
		return 0
	end
	
	
=begin
From here on, we will be checking if the submitted period overlaps with any of the other periods the grader specified. We will not allow time overlaps.
=end
	
	#Any failed time validation will set this to 0
	valid = 1
	
	#filter by day, params[:weekday]
	grader = Grader.find_by(user_id: current_user.id)
	timesOfSelectedDay = GraderAvailability.where(["grader_id = ? and weekday = ?", grader.id, params[:weekday]])
	
	#check the range of each period in that day to make sure that the new start and new end times do not overlap with any existing period
	
	if timesOfSelectedDay.length > 0
	timesOfSelectedDay.each do |period|
		if (startTime >= period.start) && (startTime <= period.end)
			valid = 0
		end
		if (endTime >= period.start) && (endTime <= period.end)
			valid = 0
		end
		if (period.start >= startTime) && (period.start <= endTime)
			valid = 0
		end
		if (period.end >= startTime) && (period.end <= endTime)
			valid = 0
		end
		
	end
	end
	
	
	if valid == 0
		flash[:overlap] = 'Your submitted new time cannot overlap with an existing time!'
		redirect_to '/grader/schedule_edit'
		return 0
	end
	
	#If execution reaches here, we can save the record.
	newPeriod = GraderAvailability.new(grader_id: current_user.grader.id, weekday: params[:weekday], start: startTime, end: endTime)
	newPeriod.save
	redirect_to '/grader/schedule_edit'
end

# Runs when grader clicks on the delete button of one of their existing available timeslots
def time_delete
	
	@period = GraderAvailability.find(params[:id])
	
	#Make sure that current user actually owns the time record
	if current_user.grader.id == @period.grader_id
		@period.destroy
	else
		flash[:bad] = 'ERROR'
	end
	
	redirect_to '/grader/schedule_edit'
	
end

#TODO: 
def create_profile
	
	if (Grader.find_by(user_id: current_user.id) == nil)
		Grader.create(user_id: current_user.id)
	end
	
	redirect_to '/grader'
	
	
	#add this as a route
	#create this button in the user or home screen
	#on button click, create the profile
	#check is user currently has a profile, abort if so
	
end


#class definition end	
end

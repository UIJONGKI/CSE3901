class CoursesController < ApplicationController
	#Course controller handles everything related to displaying and altering course info
	
	include HTTParty  #for httpartyGet function
  
	
	#Course-related pages are restricted to registered users only.
	#Some features are exclusive to admins
	#These functions redirect users to a descriptive error page.
    	before_action :checkLogin
    	before_action :checkAdmin, only: [ :new, :edit, :create, :update, :destroy ]
	
	#Allows these methods access to the course of interest
	before_action :set_course, only: [ :edit, :update, :destroy ]

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
		#double check this line
		return true
	end
end

# GET /courses or /courses.json (display full list of courses)
def index
	@courses = filter(Course.all)
end

# Any /courses/(value) route calls upon this function - handles both /courses/reload and 
# /courses/(course_id)
def decision
	#decision for id and reload
	if params[:id].to_i > 0  # /courses/(course_id)
		@course = set_course
		show
	elsif (params[:id] == "reload") && current_user.has_any_role?(:admin)  # /courses/reload, requires admin role
		reload
	elsif (params[:id] == "reload") && !current_user.has_any_role?(:admin) # throw error if not an admin...
		flash[:user_error] = 'You do not have proper permissions to access this feature.'
		#fix double render
		redirect_to '/error'
	end 
end

# GET /courses/1 or /courses/1.json (display the details for a single course, and its sections) - depends upon decision function, defined above
def show
  	# Needed for the "Add a Section" link
  	@course_id = @course.id
  	# Needed to display list of sections
  	@sections = @course.sections
  	render :show
end

# GET /courses/new
def new
	@course = Course.new
end

# GET /courses/1/edit
def edit
	
end

# POST /courses or /courses.json
def create
	@course = Course.new(course_params)

    	respond_to do |format|
      		if @course.save
        		format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        		format.json { render :show, status: :created, location: @course }
      		else
        		format.html { render :new, status: :unprocessable_entity }
        		format.json { render json: @course.errors, status: :unprocessable_entity }
      		end
    	end
end

# PATCH/PUT /courses/1 or /courses/1.json
def update
    	respond_to do |format|
      		if @course.update(course_params)
        		format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        		format.json { render :show, status: :ok, location: @course }
      		else
        		format.html { render :edit, status: :unprocessable_entity }
        		format.json { render json: @course.errors, status: :unprocessable_entity }
      		end
    	end
end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    
    sections = @course.sections
    sections.destroy_all
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #Sets what filter categories are allowed and gets them from the url
  def filter_params
    params.fetch(:filter, {}).permit(:courseNumber, :courseName, :inClassGraders)
  end

  #Sanitizes parameter input and runs sql query
  def filter(relation)
    v = filter_params
    v.compact_blank!
    return relation unless v.present?
      relation.where(v)
    end
  end
  
  #Runs when the 'courses/reload' route is accessed. Exclusive to Admins. 
  def reload
    #Wipes entire course/section database
    oldSections = Section.all
    oldSections.destroy_all
    oldCourses = Course.all
    oldCourses.destroy_all
    
    #Retrieves data anew from OSU website
    courses = httpartyGet
    parseCourses(courses)
    
    #Refreshes course page
    redirect_to '/courses'
  end
  
  #Retrieves course catalog information from OSU as JSON, and converts it into a Ruby array containing both section and course information
  private def httpartyGet
    url="https://content.osu.edu/v2/classes/search?q=cse&campus=col&term=1224&p=1&subject=cse&academic-career=ugrd"
    response=HTTParty.get(url)
    #response.body is the HTTP response body in string format. 
    #in this case it contains the JSON file
    #converts that string to a hash
    r_hash = JSON.parse(response.body)

    #the commented out line of code writes the json file to a file
    #copy and paste this file into https://jsonformatter.curiousconcept.com/# to get an interactive JSON
    File.open('myfile', 'w'){|file|file.write(response.body)}

    #Formatting the body of the HTTP response to access the data we'll need
    r_array = r_hash.to_a[0]
    data=r_array[1].to_a
    #Crop the array down to just the courses and sections information
    data.shift(11)
    #more formatting
    courses=data[0][1]
  end  

#Converts an array containing courses with nested course and sections hashes
  #Into model objects that can be added to the database; a partial JSON file. 
  #Meant to take the return from httpartyGet
  def parseCourses(courses)
    courses.each do |course|
      check = course['course']
      course_courseNumber = course['course']['catalogNumber']
      course_courseName = course['course']['title']
      course_term = course['course']['term']
      existing_course = Course.find_by(courseNumber: course_courseNumber)
      course_object = existing_course || Course.create(courseNumber: course_courseNumber, courseName: course_courseName)
      sections = course['sections']
      sections.each do |section|
        section_sectionNumber = section['section']
        section_buildingAndRoom = section['meetings'][0]['buildingDescription']
        section_instructor = section['meetings'][0]['instructors'][0]['displayName']
        section_instructorEmail = section['meetings'][0]['instructors'][0]['email']
        @section_object = Section.create(sectionNumber: section_sectionNumber, 
          course_id: course_object.id, 
          buildingAndRoom: section_buildingAndRoom, 
          instructor: section_instructor, 
          term: course_term, 
          instructorEmail: section_instructorEmail)
        meetings = section['meetings']
        meetings.each do |meeting|
          date = meeting['startDate']
          startTime_str = meeting['startTime']
          weekday_arr = findWeekdays(meeting)
          weekday_arr.each do |day|
            startTime = Time.parse(startTime_str)
            endTime_str = meeting['endTime']
            endTime = Time.parse(endTime_str)
            @schedule_object = SectionSchedule.create(weekday: day, 
              startTime: startTime, 
              endTime: endTime, 
              section_id: @section_object.id)
          end
        end
      end
    end
  end
  
  #converst string of time into seconds since midnight, based on a date. 
  private def parseTime(str, date)
    time = Time.parse(str)
    start = Date.parse(date)
    start = Time.new(start.year, start.month, start.mday)
    time = start-time
  end

  private def findWeekdays(meeting)
    a = []
    a << 'Monday' if meeting['monday']
    a << 'Tuesday' if meeting['tuesday']
    a << 'Wednesday' if meeting['wednesday']
    a << 'Thursday' if meeting['thursday']
    a << 'Friday' if meeting['friday']
    a << 'Saturday' if meeting['saturday']
    a << 'Sunday' if meeting['sunday']
    a
  end

  # Use callbacks to share common setup or constraints between actions.
  private def set_course
    @course = Course.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  private def course_params
    params.require(:course).permit(:courseNumber, :courseName, :inClassGraders)
  end




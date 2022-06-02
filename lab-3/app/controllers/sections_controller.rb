class SectionsController < ApplicationController
 	#Section controller handles everything related to displaying and altering section info
	
	#Section-related pages are restricted to registered users only.
	#Some features are exclusive to admins
	#These functions redirect users to a descriptive error page.
    	before_action :checkLogin
    	before_action :checkAdmin, only: [ :new, :edit, :create, :update, :destroy ]

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
  
  before_action :set_section, only: %i[ show edit update destroy ]
  before_action :only => [:edit, :destroy] do
    redirect_to '/' unless current_user.has_any_role? :admin
  end
  
  # Function runs when user accesses the /sections route - we do not wish to display anything here, and instead ask the user to view sections through a specific course's page isntead.
  def index
    flash.now[:section_collection] = 'Please go to the Courses page to view sections for a particular course!'
  end

  # GET /sections/1 or /sections/1.json
  def show
    unless @section.instructor?
      @instructor = "Unassigned"
      @instructorEmail = "Unassigned"
    end
    unless @section.buildingAndRoom?
      @buildingAndRoom="Unassigned"
    end
    begin
      @course_id=Course.find(Section.course_id)
    rescue
      flash.alert = "Error finding Course Number"
      @course_id=-1
    end
    @section_schedules = @section.section_schedules
  end

# GET /sections/new - control code requires that this route has a query that we specified as :course, which is appended to a URL when the user clicks on the "Add a Section" link while viewing a specific course. If this query is not present in the URL, we throw an error and tell the user to create a new Section through a course page.
def new
    	@course = Course.find params[:course].to_i
    	@section = Section.new
    
    	if (params[:course] == nil) || (params[:course].to_i == nil)
    		flash[:user_error] = 'Please add sections directly from a course\'s page!'
		redirect_to '/error'
		return 0
    	end
    	
    	@course_id = params[:course].to_i
end

  # GET /sections/1/edit
  def edit
  	@course_id = Section.find(params[:id]).course_id
  end

# POST /sections or /sections.json
def create
	@section = Section.new(section_params)
    
    	respond_to do |format|
      		if @section.save
      			format.html { redirect_to section_url(@section), notice: "Section was successfully created." }
        		format.json { render :show, status: :created, location: @section }
      		else
        		flash[:course_error] = 'You did not fill out all fields in the section form. Please return to the course of interest and refill the form.'
        		format.html { render :index, status: :unprocessable_entity }
        		format.json { render json: @section.errors, status: :unprocessable_entity }
        		
      		end
    	end
end

  # PATCH/PUT /sections/1 or /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to section_url(@section), notice: "Section was successfully updated." }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1 or /sections/1.json
  def destroy
    @section = Section.find(params[:id])
    @course_id = @section.course_id
    @section.destroy

    respond_to do |format|
      format.html { redirect_to course_path(@course_id), notice: "Section was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  #Filters are unused
  def filter_params
    params.fetch(:filter, {}).permit(:instructor, :term, :positionsOpen, :courseNumber)
  end

  def filter(relation)
    v = filter_params
    v.compact_blank!
    return relation unless v.present?
      relation.where(v)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    private def section_params
      params.require(:section).permit(:sectionNumber, :course_id, :instructor, :instructorEmail, :term, :buildingAndRoom, :numGradersNeeded)
    end

    

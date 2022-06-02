class SectionSchedulesController < ApplicationController
  before_action :set_section_schedule, only: %i[ show edit update ]

  # From route 'sections/:id/schedule_edit'
  def index
    
    @section = Section.find(params[:id])
    @section_schedules = @section.section_schedules
  end

  # GET /section_schedules/1 or /section_schedules/1.json
  def show
  end

  # GET /section_schedules/new
  def new
    @section_schedule = SectionSchedule.new
  end

  # GET /section_schedules/1/edit
  def edit
  end

  # Called when admin is on /sections/:section_id/schedule_edit page, then submits a new time to add
  def create
    
    section = Section.find(params[:id])
    @section_schedule = SectionSchedule.create(section_id: section.id, startTime: Time.parse(params[:startTime]), endTime: Time.parse(params[:endTime]), weekday: params[:weekday])

    redirect_to '/sections/' + section.id.to_s + '/schedule_edit', notice: "Section schedule was successfully created."
    
  end

  # PATCH/PUT /section_schedules/1 or /section_schedules/1.json
  def update
    respond_to do |format|
      if @section_schedule.update(section_schedule_params)
        format.html { redirect_to section_schedule_url(@section_schedule), notice: "Section schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @section_schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /section_schedules/1 or /section_schedules/1.json
  def destroy
    @section_schedule = SectionSchedule.find(params[:id])
    @original_section = @section_schedule.section
    @section_schedule.destroy

    respond_to do |format|
      format.html { redirect_to '/sections/' + @original_section.id.to_s + '/schedule_edit', notice: "Section schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section_schedule
      @section_schedule = SectionSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def section_schedule_params
      params.require(:section_schedule).permit(:weekday, :startTime, :endTime)
    end
end

require "test_helper"

class SectionSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section_schedule = section_schedules(:one)
  end

  test "should get index" do
    get section_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_section_schedule_url
    assert_response :success
  end

  test "should create section_schedule" do
    assert_difference('SectionSchedule.count') do
      post section_schedules_url, params: { section_schedule: { end: @section_schedule.end, start: @section_schedule.start, weekday: @section_schedule.weekday } }
    end

    assert_redirected_to section_schedule_url(SectionSchedule.last)
  end

  test "should show section_schedule" do
    get section_schedule_url(@section_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_section_schedule_url(@section_schedule)
    assert_response :success
  end

  test "should update section_schedule" do
    patch section_schedule_url(@section_schedule), params: { section_schedule: { end: @section_schedule.end, start: @section_schedule.start, weekday: @section_schedule.weekday } }
    assert_redirected_to section_schedule_url(@section_schedule)
  end

  test "should destroy section_schedule" do
    assert_difference('SectionSchedule.count', -1) do
      delete section_schedule_url(@section_schedule)
    end

    assert_redirected_to section_schedules_url
  end
end

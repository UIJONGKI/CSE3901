require "test_helper"

class GraderSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grader_schedule = grader_schedules(:one)
  end

  test "should get index" do
    get grader_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_grader_schedule_url
    assert_response :success
  end

  test "should create grader_schedule" do
    assert_difference('GraderSchedule.count') do
      post grader_schedules_url, params: { grader_schedule: { end: @grader_schedule.end, start: @grader_schedule.start, weekday: @grader_schedule.weekday } }
    end

    assert_redirected_to grader_schedule_url(GraderSchedule.last)
  end

  test "should show grader_schedule" do
    get grader_schedule_url(@grader_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_grader_schedule_url(@grader_schedule)
    assert_response :success
  end

  test "should update grader_schedule" do
    patch grader_schedule_url(@grader_schedule), params: { grader_schedule: { end: @grader_schedule.end, start: @grader_schedule.start, weekday: @grader_schedule.weekday } }
    assert_redirected_to grader_schedule_url(@grader_schedule)
  end

  test "should destroy grader_schedule" do
    assert_difference('GraderSchedule.count', -1) do
      delete grader_schedule_url(@grader_schedule)
    end

    assert_redirected_to grader_schedules_url
  end
end

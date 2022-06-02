require "application_system_test_case"

class GraderSchedulesTest < ApplicationSystemTestCase
  setup do
    @grader_schedule = grader_schedules(:one)
  end

  test "visiting the index" do
    visit grader_schedules_url
    assert_selector "h1", text: "Grader Schedules"
  end

  test "creating a Grader schedule" do
    visit grader_schedules_url
    click_on "New Grader Schedule"

    fill_in "End", with: @grader_schedule.end
    fill_in "Start", with: @grader_schedule.start
    fill_in "Weekday", with: @grader_schedule.weekday
    click_on "Create Grader schedule"

    assert_text "Grader schedule was successfully created"
    click_on "Back"
  end

  test "updating a Grader schedule" do
    visit grader_schedules_url
    click_on "Edit", match: :first

    fill_in "End", with: @grader_schedule.end
    fill_in "Start", with: @grader_schedule.start
    fill_in "Weekday", with: @grader_schedule.weekday
    click_on "Update Grader schedule"

    assert_text "Grader schedule was successfully updated"
    click_on "Back"
  end

  test "destroying a Grader schedule" do
    visit grader_schedules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Grader schedule was successfully destroyed"
  end
end

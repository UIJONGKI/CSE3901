require "application_system_test_case"

class SectionSchedulesTest < ApplicationSystemTestCase
  setup do
    @section_schedule = section_schedules(:one)
  end

  test "visiting the index" do
    visit section_schedules_url
    assert_selector "h1", text: "Section Schedules"
  end

  test "creating a Section schedule" do
    visit section_schedules_url
    click_on "New Section Schedule"

    fill_in "End", with: @section_schedule.end
    fill_in "Start", with: @section_schedule.start
    fill_in "Weekday", with: @section_schedule.weekday
    click_on "Create Section schedule"

    assert_text "Section schedule was successfully created"
    click_on "Back"
  end

  test "updating a Section schedule" do
    visit section_schedules_url
    click_on "Edit", match: :first

    fill_in "End", with: @section_schedule.end
    fill_in "Start", with: @section_schedule.start
    fill_in "Weekday", with: @section_schedule.weekday
    click_on "Update Section schedule"

    assert_text "Section schedule was successfully updated"
    click_on "Back"
  end

  test "destroying a Section schedule" do
    visit section_schedules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Section schedule was successfully destroyed"
  end
end

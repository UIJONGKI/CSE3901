class AddSectionToSectionSchedule < ActiveRecord::Migration[6.1]
  def change
    add_reference :section_schedules, :section, foreign_key: true
  end
end

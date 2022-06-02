class DropGraderSchedules < ActiveRecord::Migration[6.1]
  def change
  	drop_table :grader_schedules
  end
end

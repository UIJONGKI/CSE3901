class RenameEndToEndTime < ActiveRecord::Migration[6.1]
  def change
    rename_column :section_schedules, :end, :endTime
    rename_column :grader_schedules, :end, :endTime
  end
end

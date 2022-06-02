class RenameStartToStartTime < ActiveRecord::Migration[6.1]
  def change
    rename_column :section_schedules, :start, :startTime
    rename_column :grader_schedules, :start, :startTime
  end
end

class DropTimesAndCoursesFromGrader < ActiveRecord::Migration[6.1]
  def change
  	remove_column :graders, :monday_times, :string
  	remove_column :graders, :tuesday_times, :string
  	remove_column :graders, :wednesday_times, :string
  	remove_column :graders, :thursday_times, :string
  	remove_column :graders, :friday_times, :string
  	remove_column :graders, :qualified_courses, :string
  	remove_column :graders, :interested_courses, :string
  end
end

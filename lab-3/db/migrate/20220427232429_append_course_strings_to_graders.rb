class AppendCourseStringsToGraders < ActiveRecord::Migration[6.1]
  def change
  	add_column :graders, :qualified_courses, :string
  	add_column :graders, :interested_courses, :string
  end
end

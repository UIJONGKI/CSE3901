class CreateCourseQualifications < ActiveRecord::Migration[6.1]
  def change
    create_table :course_qualifications do |t|

      t.belongs_to :grader
      t.belongs_to :course
      t.integer :course_number
      t.timestamps
    end
  end
end

class AddCourseToSections < ActiveRecord::Migration[6.1]
  def change
    add_reference :sections, :course, foreign_key: true
  end
end

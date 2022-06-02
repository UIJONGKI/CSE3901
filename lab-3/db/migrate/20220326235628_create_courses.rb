class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.integer :courseNumber
      t.string :courseName
      t.boolean :inClassGraders, default: false

      t.timestamps
    end
  end
end

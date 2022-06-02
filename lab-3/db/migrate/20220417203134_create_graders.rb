class CreateGraders < ActiveRecord::Migration[6.1]
  def change
    create_table :graders do |t|
	
	t.belongs_to :user
	t.boolean :currently_interested, default: false
	t.string :monday_times
	t.string :tuesday_times
	t.string :wednesday_times
	t.string :thursday_times
	t.string :friday_times
	t.text :resume, default: ""
	t.string :qualified_courses
	t.string :interested_courses
	
      t.timestamps
    end
    
  end
end

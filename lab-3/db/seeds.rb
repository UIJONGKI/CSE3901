require_relative "../app/controllers/courses_controller.rb"
require_relative "../app/helpers/section_schedules_helper.rb"

#Generates a default admin-level account for this database
User.create!({:email => 'admin.1@osu.edu', :password => '123456', :password_confirmation => '123456'})
admin = User.find_by email: 'admin.1@osu.edu'
admin.add_role 'admin'
oldRole = Role.find_by id: 1
admin.remove_role oldRole.name
admin.save

#Seeds the database with courses from OSU's API
courses = httpartyGet
parseCourses(courses)


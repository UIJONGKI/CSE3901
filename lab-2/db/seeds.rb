
#Generates a default admin-level account for this database
User.create!({:email => 'admin.1@osu.edu', :password => '123456', :password_confirmation => '123456'})
admin = User.find_by email: 'admin.1@osu.edu'
admin.add_role 'admin'

oldRole = Role.find_by id: 1
admin.remove_role oldRole.name
admin.save



# The rest of this file matches the methods httpartyGet and parseCourses in controller.rb, filling the database with CSE course and section info returned from the API with the URL below. See their documentation there.

url="https://content.osu.edu/v2/classes/search?q=cse&campus=col&p=1&subject=cse&academic-career=ugrd"

response=HTTParty.get(url)
r_hash = JSON.parse(response.body)
File.open('myfile', 'w'){|file|file.write(response.body)}
r_array = r_hash.to_a[0]
data=r_array[1].to_a
data.shift(11)
courses=data[0][1]
courses_array=[]
sections_array=[]
courses.each do |course|
	check = course["course"]
	course_courseNumber = course["course"]["catalogNumber"]
	course_courseName = course["course"]["title"]
	course_term = course["course"]["term"]
	existing_course = Course.find_by(courseNumber: course_courseNumber)
	unless existing_course
		course_object=Course.create(courseNumber: course_courseNumber, courseName: course_courseName)
	else
		course_object=existing_course
	end
	sections = course["sections"]
	sections.each do |section|
		section_sectionNumber = section["section"]
		section_buildingAndRoom = section["meetings"][0]["buildingDescription"]
		section_instructor = section["meetings"][0]["instructors"][0]["displayName"]
		section_instructorEmail = section["meetings"][0]["instructors"][0]["email"]
		Section.create(sectionNumber: section_sectionNumber, course_id: course_object.id, buildingAndRoom: section_buildingAndRoom, instructor: section_instructor, term: course_term, instructorEmail: section_instructorEmail)
		end
end




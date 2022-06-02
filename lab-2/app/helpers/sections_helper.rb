module SectionsHelper
	#This file is unused for this project, its content is saved for project 3
	def findCourse(section)
		Course.find(section.course_id)
	end

	def findCourseNumber(section)
		findCourse(section).courseNumber.to_s
	end

	def findFormattedCourseNumber(section)
		courseNumberString = "CSE" + findCourseNumber(section)
		#This line might not be necessary
		courseNumberSym = courseNumberString.to_sym
	end

	def findCourseName(section)
		findCourse(section).courseName
	end

	def findInClass?(section)
		findCourse(section)
	end

	def options(column_name)
		column_name.to_sym
		options = Section.findOptions(column_name)
		options.compact!
	end

	#def createSelectionsHash(Model)
		#h = Hash.new
		#model.attribute_names.each do |columnName|
			#col = columnName.to_sym
			#results = findOptions(model, col)
			#h[col]=results
		#end
	#end
end

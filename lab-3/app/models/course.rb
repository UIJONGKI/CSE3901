class Course < ApplicationRecord
	# Course can have many sections. If course is deleted, delete all of its sections.
	has_many :sections, :dependent => :delete_all 
	has_many :section_schedules, :through => :sections
	has_many :course_qualifications
	has_many :course_interests

end

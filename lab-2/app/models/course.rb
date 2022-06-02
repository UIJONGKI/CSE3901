class Course < ApplicationRecord
	# Course can have many sections. If course is deleted, delete all of its sections.
	has_many :sections, :dependent => :delete_all 
end

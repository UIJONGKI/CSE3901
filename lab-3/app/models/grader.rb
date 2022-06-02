class Grader < ApplicationRecord
	belongs_to :user
	has_many :assignments
	has_many :grader_availabilities
	has_many :course_qualifications
	has_many :course_interests
	
	has_many :grader_assignments
	has_many :sections, through: :grader_assignments
	
end

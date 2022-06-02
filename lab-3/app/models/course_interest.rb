class CourseInterest < ApplicationRecord
	belongs_to :grader
	belongs_to :course, optional: true
end

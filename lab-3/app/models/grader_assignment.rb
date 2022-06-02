class GraderAssignment < ApplicationRecord
	
	belongs_to :grader
	belongs_to :section
	
end

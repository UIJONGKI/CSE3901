module RecommendationsHelper
	def mySections
		@sections = Section.where(instructorEmail: current_user.email)
	end
	def myGraders(s_id)
		@graders = GraderAssignment.where(section_id: s_id)
	end
end

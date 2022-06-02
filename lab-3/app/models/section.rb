class Section < ApplicationRecord
	#Section must be associated with a course
	belongs_to :course
	has_many :section_schedules, :dependent => :delete_all

	has_many :grader_assignments, :dependent => :delete_all
	has_many :graders, through: :grader_assignments
	
	validates :sectionNumber, :instructor, :instructorEmail, :term, :buildingAndRoom, :numGradersNeeded, presence: true
	#Checks for email matching OSU format.
	validates :instructorEmail, format: {with: /[a-z]+\.[1-9]\d*@osu\.edu/, message: 'Must match OSU name.# format!'}

	def self.findOptions(column)
		self.distinct.pluck(column)
	end
end

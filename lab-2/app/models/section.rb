class Section < ApplicationRecord
	#Section must be associated with a course
	belongs_to :course
	
	validates :sectionNumber, :instructor, :instructorEmail, :term, :buildingAndRoom, :numGradersNeeded, presence: true
	
	def self.findOptions(column)
		self.distinct.pluck(column)
	end
end

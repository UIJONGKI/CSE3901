class Recommendation < ApplicationRecord

	#Checks for email matching OSU format.
	validates :email, format: {with: /[a-z]+\.[1-9]\d*@osu\.edu/, message: 'Must match OSU name.# format!'}
end

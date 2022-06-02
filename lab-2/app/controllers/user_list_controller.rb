require_relative '../models/user.rb' 

class UserListController < ApplicationController
	def show
		@users = User.all
	end
end

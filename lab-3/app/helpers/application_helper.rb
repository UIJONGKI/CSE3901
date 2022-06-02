module ApplicationHelper
	
	def prettyTime(t)
		s = Time.at(t).strftime('%l:%M %p')
	end

	def createFormObjFromParam(param)
		form_params = params.fetch(param, {})
		form_reqs = {model_name: {param_key: param}}
		JSON.parse(form_params.merge(form_reqs).to_json, 
								object_class: OpenStruct)
	end

	def getFullName(id)
		user = User.find id
		if user.first_name and user.last_name 
			fullName=user.first_name + ' ' + user.last_name
		else
			fullName = user.email
		end
		return fullName
	end
end

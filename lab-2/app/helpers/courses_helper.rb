module CoursesHelper
	def createFormObjFromParam(param)
		form_params = params.fetch(param, {})
		form_reqs = {model_name: {param_key: param}}
		JSON.parse(form_params.merge(form_reqs).to_json, 
								object_class: OpenStruct)
	end
end

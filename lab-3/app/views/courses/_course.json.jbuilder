json.extract! course, :id, :courseNumber, :courseName, :inClassGraders, :created_at, :updated_at
json.url course_url(course, format: :json)

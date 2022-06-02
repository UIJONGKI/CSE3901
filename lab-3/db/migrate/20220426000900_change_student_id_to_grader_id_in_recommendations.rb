class ChangeStudentIdToGraderIdInRecommendations < ActiveRecord::Migration[6.1]
  def change
    rename_column :recommendations, :student_id, :grader_id
  end
end

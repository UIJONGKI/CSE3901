class AddStudentToRecommendation < ActiveRecord::Migration[6.1]
  def change
    add_reference :recommendations, :user, foreign_key: true
    rename_column :recommendations, :user_id, :student_id
  end
end

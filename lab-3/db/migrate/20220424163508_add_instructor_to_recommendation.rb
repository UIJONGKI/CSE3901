class AddInstructorToRecommendation < ActiveRecord::Migration[6.1]
  def change
    add_reference :recommendations, :user, foreign_key: true
    rename_column :recommendations, :user_id, :instructor_id
  end
end

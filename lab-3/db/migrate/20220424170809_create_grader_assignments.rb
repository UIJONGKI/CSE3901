class CreateGraderAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :grader_assignments do |t|
	
	t.belongs_to :grader
	t.belongs_to :section
	
      t.timestamps
    end
  end
end

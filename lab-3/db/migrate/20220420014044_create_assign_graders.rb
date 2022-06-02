class CreateAssignGraders < ActiveRecord::Migration[6.1]
  def change
    create_table :assign_graders do |t|
      t.references :section, null: false, foreign_key: true
      t.references :grader, null: false, foreign_key: true

      t.timestamps
    end
  end
end

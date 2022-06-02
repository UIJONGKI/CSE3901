class CreateGraderAvailabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :grader_availabilities do |t|
      
      t.belongs_to :grader
      t.string :weekday
      t.integer :start
      t.integer :end
      t.timestamps
      
    end
  end
end

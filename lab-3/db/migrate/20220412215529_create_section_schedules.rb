class CreateSectionSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :section_schedules do |t|
      t.string :weekday
      t.integer :start
      t.integer :end

      t.timestamps
    end
  end
end

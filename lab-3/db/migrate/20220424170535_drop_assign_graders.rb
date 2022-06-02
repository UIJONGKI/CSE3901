class DropAssignGraders < ActiveRecord::Migration[6.1]
  def change
  	drop_table :assign_graders
  end
end

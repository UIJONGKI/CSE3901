class ModifyIntructorForSections < ActiveRecord::Migration[6.1]
  def change
    add_reference :sections, :user, foreign_key: true
    rename_column :sections, :user_id, :instructor_id
  end
end

class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.integer :sectionNumber
      t.string :instructor
      t.string :instructorEmail
      t.string :term
      t.string :buildingAndRoom
      t.integer :numGradersNeeded, default: 1
      t.boolean :positionsOpen, default: true

      t.timestamps
    end
  end
end

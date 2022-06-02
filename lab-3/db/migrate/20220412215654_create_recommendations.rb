class CreateRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendations do |t|
      t.text :letter

      t.timestamps
    end
  end
end

class AddEmailToRecommendation < ActiveRecord::Migration[6.1]
  def change
    add_column :recommendations, :email, :string
  end
end

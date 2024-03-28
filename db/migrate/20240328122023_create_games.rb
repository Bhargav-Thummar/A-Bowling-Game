class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :player_name
      t.integer :total_score, default: 0

      t.timestamps
    end
  end
end

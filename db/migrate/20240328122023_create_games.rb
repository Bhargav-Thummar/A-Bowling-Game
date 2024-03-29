class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :player_name

      t.timestamps
    end
  end
end

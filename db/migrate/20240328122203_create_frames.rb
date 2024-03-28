class CreateFrames < ActiveRecord::Migration[7.0]
  def change
    create_table :frames do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :position, default: 0
      t.integer :slot_1_points
      t.integer :slot_2_points
      t.integer :slot_3_points
      t.integer :status, default: 1 # completed
      t.integer :frame_total, default: 0

      t.timestamps
    end
  end
end

# == Schema Information
#
# Table name: frames
#
#  id            :bigint           not null, primary key
#  position      :integer          default(0)
#  slot_1_points :integer          default(0)
#  slot_2_points :integer          default(0)
#  slot_3_points :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  game_id       :bigint           not null
#
# Indexes
#
#  index_frames_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#

class FrameSerializer < ActiveModel::Serializer
  attributes :id, :position, :slot_1_points, :slot_2_points, :slot_3_points, :score

  def score
    0.0
  end
end

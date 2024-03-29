# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  player_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Game < ApplicationRecord
  # validations
  validates :player_name, presence: true

  # associations
  has_many :frames, inverse_of: :game, dependent: :destroy

  def add_score(score: 0)
    frames.active_frame.add_score(score: score)
  end

  def total_score
    frames.find_by_position(10)&.frame_total || 0
  end
end

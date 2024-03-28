# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  player_name :string
#  total_score :integer          default(0)
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
end

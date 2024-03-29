# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  player_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GameSerializer < ActiveModel::Serializer
  has_many :frames

  attributes :id, :player_name, :total_score

  def total_score
    @object.frames.last.frame_total
  end
end

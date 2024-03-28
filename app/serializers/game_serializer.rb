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

class GameSerializer < ActiveModel::Serializer
  has_many :frames

  attributes :id, :player_name, :total_score
end

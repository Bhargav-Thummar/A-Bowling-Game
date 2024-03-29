# == Schema Information
#
# Table name: frames
#
#  id            :bigint           not null, primary key
#  frame_total   :integer          default(0)
#  position      :integer          default(0)
#  slot_1_points :integer
#  slot_2_points :integer
#  slot_3_points :integer
#  status        :integer          default("completed")
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

class Frame < ApplicationRecord
  # It will set position when frame creates
  acts_as_list scope: :game_id

  # associations
  belongs_to :game, inverse_of: :frames

  # validations
  before_validation :frame_position, on: :create
  validate :frame_slot_score

  # To define status of frame
  enum :status, [ :active, :completed ]

  # scopes
  default_scope { order(:position) }

  # class methods
  def self.active_frame
    active_frame = active.last
    unless active_frame.present?
      active_frame = create(status: :active)
    end

    active_frame
  end

  # instance methods
  def add_score(score: 0)
    # assign score
    assign_score(score: score)

    # mark frame as a completed
    mark_frame_as_completed(score: score)

    # save frame
    self.save

    # calculate frame total score
    calculate_frame_total

    self
  end

  private

    # custom validation methods
    def frame_position
      if game.frames.count >= 10
        errors.add(:frame_position, I18n.t("errors.limit"))
      end
    end
  
    def frame_slot_score
      if position < 10
        # position is less than 10 but sum of points of slot-1 & slot-2 is greater than 10
        if (slot_1_points.to_i + slot_2_points.to_i) > 10
          errors.add(:frame_total, I18n.t("errors.limit"))
        end

      elsif position == 10
        # all points is greater than 10
        if slot_1_points.to_i > 10 || slot_2_points.to_i > 10 || slot_3_points.to_i > 10
          errors.add(:frame_total, I18n.t("errors.limit"))

        # points of slot-1 & slot-2 is 10 but points slot-3 is greater than 10
        elsif slot_1_points.to_i == 10 && slot_2_points.to_i == 10 && slot_3_points.to_i > 10
          errors.add(:slot_3_points, I18n.t("errors.limit"))

        # slot-1 is 10 but sum of points of slot-2 & slot-3 are greater than 10
        elsif slot_1_points.to_i == 10 && slot_2_points.to_i < 10 && slot_3_points.to_i <= 10
          if (slot_2_points.to_i + slot_3_points.to_i) > 10
            errors.add(:frame_total, I18n.t("errors.limit"))
          end

        # sum of points of slot-1 & slot-2 are greater than 10 and point of slot-3 is also greater than 10
        elsif (slot_1_points.to_i + slot_2_points.to_i) == 10 && slot_3_points.to_i > 10
          errors.add(:slot_3_points, I18n.t("errors.limit"))

        # sum of all points are greater than 10 but sum of any 2 points is less than 10
        elsif slot_1_points.to_i < 10 && slot_2_points.to_i < 10 && slot_3_points.to_i <= 10
          if (slot_1_points.to_i + slot_2_points.to_i + slot_3_points.to_i) > 10
            errors.add(:frame_total, I18n.t("errors.limit"))
          end
        end
      end
    end
 
    def assign_score(score: 0)
      # assign score
      if slot_1_points.nil?
        self.slot_1_points = score
      elsif slot_2_points.nil?
        self.slot_2_points = score
      elsif (position == 10 && slot_3_points.nil?)
        self.slot_3_points = score
      end
    end

    def mark_frame_as_completed(score: 0)
      if (position < 10 && (score == 10 || slot_2_points_changed?)) || slot_3_points_changed?
        self.status = :completed
      end
    end

    def calculate_frame_total

    end
end


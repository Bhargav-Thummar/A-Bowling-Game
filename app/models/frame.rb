# == Schema Information
#
# Table name: frames
#
#  id            :bigint           not null, primary key
#  frame_total   :integer
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
  enum :status, %i[active completed]

  # scopes
  default_scope { order(:position) }

  # class methods
  def self.active_frame
    active_frame = active.last
    active_frame = create(status: :active) unless active_frame.present?

    active_frame
  end

  # instance methods
  def add_score(score: 0)
    # assign score
    assign_score(score:)

    # mark frame as a completed
    mark_frame_as_completed(score:)

    # calculate frame total score
    calculate_total

    # save frame
    save

    # return self
    self
  end

  private

  # custom validation methods
  def frame_position
    return unless game.frames.count >= 10

    # if frame count id greater than 10
    errors.add(:frame_position, I18n.t('errors.position_limit'))
  end

  def frame_slot_score
    slot_points = [slot_1_points.to_i, slot_2_points.to_i, slot_3_points.to_i]

    # position is less than 10 but sum of points of slot-1 & slot-2 is greater than 10
    if position < 10 && slot_points[0] + slot_points[1] > 10
      errors.add(:score_value, I18n.t('errors.frame_total'))

    elsif position == 10
      # any of slot point is greater than 10
      if slot_points.any? { |points| points > 10 }
        errors.add(:score_value, I18n.t('errors.frame_total'))

      # slot-1 is not quals to 10 but slot-1 + slot-2 greater than 10
      elsif slot_points[0] != 10 && slot_points[0] + slot_points[1] > 10
        errors.add(:score_value, I18n.t('errors.frame_total'))

      elsif slot_points[1] <= 10 && slot_points[2] <= 10
        # slot-1 is 10 but sum of points of slot-2 & slot-3 are greater than 10
        if slot_points[0] == 10
          if slot_points[1] != 10 && slot_points[1] + slot_points[2] > 10
            errors.add(:score_value, I18n.t('errors.frame_total'))
          end

        # sum of 2 points is greater than 10 OR sum of all points is greater than 10
        elsif slot_points[0] < 10 && slot_points[0] + slot_points[1] != 10
          if slot_points[0] + slot_points[1] < 10 && slot_points.sum > 10
            errors.add(:score_value, I18n.t('errors.frame_total'))
          end
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
    elsif position == 10 && slot_3_points.nil?
      self.slot_3_points = score
    end
  end

  def mark_frame_as_completed(score: 0)
    return unless (position < 10 && (score == 10 || slot_2_points_changed?)) || slot_3_points_changed?

    self.status = :completed
  end

  def calculate_total
    first_previous_frame = higher_item
    second_previous_frame = first_previous_frame&.higher_item
    third_previous_frame = second_previous_frame&.higher_item # to get frame total of this frame

    # assign frame total in 2nd previous frame
    assign_frame_total_in_second_previous_frame(third_previous_frame:, second_previous_frame: , first_previous_frame: )

    # assign frame total in 1st previous frame
    assign_frame_total_in_first_previous_frame(second_previous_frame: , first_previous_frame: )

    # return if current frame is active along with some addition checks
    return unless completed? && ((slot_1_points.to_i + slot_2_points.to_i) < 10 || position == 10)
    
    # assign frame total in current frame
    assign_frame_total_in_current_frame(first_previous_frame: first_previous_frame)
  end

  def assign_frame_total_in_second_previous_frame(third_previous_frame:, second_previous_frame: , first_previous_frame: )
    # assign frame total in 2nd previous frame if score in yet assigned
    if second_previous_frame && second_previous_frame&.frame_total.nil?
      second_previous_frame_total =
        if second_previous_frame&.slot_1_points == 10
          10 + first_previous_frame&.slot_1_points + (first_previous_frame&.slot_2_points || slot_1_points)

        elsif (second_previous_frame&.slot_1_points&.+ second_previous_frame&.slot_2_points) == 10
          10 + first_previous_frame&.slot_1_points
        end

      # update score of second previous frame
      second_previous_frame.update(frame_total: third_previous_frame&.frame_total.to_i + second_previous_frame_total)
    end
  end

  def assign_frame_total_in_first_previous_frame(first_previous_frame: , second_previous_frame: )
     # assign frame total in 1st previous frame if score in yet assigned
     if first_previous_frame && first_previous_frame&.frame_total.nil?
      previous_frame_frame_total =
        if first_previous_frame&.slot_1_points != 10 && (first_previous_frame&.slot_1_points.to_i + first_previous_frame&.slot_2_points.to_i) == 10
          10 + slot_1_points

        elsif first_previous_frame&.slot_1_points == 10 && slot_2_points.present?
          10 + slot_1_points + slot_2_points
        end

      # update score of first previous frame
      if previous_frame_frame_total
        first_previous_frame.update(frame_total: second_previous_frame&.frame_total.to_i + previous_frame_frame_total)
      end
    end
  end

  def assign_frame_total_in_current_frame(first_previous_frame: )
    self.frame_total = first_previous_frame&.frame_total.to_i + slot_1_points.to_i + slot_2_points.to_i + slot_3_points.to_i
  end
end

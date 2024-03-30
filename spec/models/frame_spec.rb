require 'rails_helper'

RSpec.describe Frame, type: :model do
  let(:game) { Game.create(player_name: "john") }
  let(:frame) { Frame.create(game_id: game.id) }
  let(:tenth_frame) { Frame.create(game_id: game.id, position: 10) }

  describe ": validations" do
    context ": create action" do
      it "is valid with game" do
        expect(frame).to be_valid
      end
    end

    context "#add_score" do
      context "#for 1st to 9th frames" do
        it "score is valid if score is < 10" do
          frame.add_score(score: 5)
          expect(frame).to be_valid
        end

        it "score is not valid if score is > 10" do
          frame.add_score(score: 11)
          expect(frame).to_not be_valid
        end

        it "score is valid if sum of scores is <= 10" do
          frame.add_score(score: 5)
          frame.add_score(score: 5)
          expect(frame).to be_valid
        end

        it "score is not valid if score is >= 10" do
          frame.add_score(score: 5)
          frame.add_score(score: 6)
          expect(frame).to_not be_valid
        end
      end

      context "#10th frame" do
        it "score is valid if all 3 slots is > 10" do
          tenth_frame.add_score(score: 11)
          tenth_frame.add_score(score: 12)
          tenth_frame.add_score(score: 13)

          expect(tenth_frame).to_not be_valid
        end

        it "score is valid if all 3 slots is equals to 10" do
          tenth_frame.add_score(score: 10)
          tenth_frame.add_score(score: 10)
          tenth_frame.add_score(score: 10)

          expect(tenth_frame).to be_valid
        end

        it "score is valid if slot-1 & slot-2 equals 10 and slot-3 <= 10" do
          tenth_frame.add_score(score: 10)
          tenth_frame.add_score(score: 10)
          tenth_frame.add_score(score: 6)

          expect(tenth_frame).to be_valid
        end

        it "score is valid if slot-1 equals 10 and sum of slot-2 & slot-3 <= 10" do
          tenth_frame.add_score(score: 10)
          tenth_frame.add_score(score: 6)
          tenth_frame.add_score(score: 4)

          expect(tenth_frame).to be_valid
        end

        it "score is not valid if slot-1 not equals 10 and sum of slot-1 & slot-2 > 10" do
          tenth_frame.add_score(score: 6)
          tenth_frame.add_score(score: 5)

          expect(tenth_frame).to_not be_valid
        end

        it "score is not valid if slot-1 equals 10 and sum of slot-2 & slot-3 > 10" do
          tenth_frame.add_score(score: 10)
          tenth_frame.add_score(score: 5)
          tenth_frame.add_score(score: 6)

          expect(tenth_frame).to_not be_valid
        end
      end
    end
  end
end

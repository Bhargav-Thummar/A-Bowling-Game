require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.create(player_name: "john") }

  describe ": validations" do
    context ": create action" do
      it "is not valid without player name" do
        game = Game.new(player_name: nil)
        expect(game).to_not be_valid
      end

      it "is valid with player name" do
        game = Game.new(player_name: "John")
        expect(game).to be_valid
      end
    end

    context ": update action" do
      let(:game) { Game.create(player_name: "john") }

      it "is not valid with player name nil" do
        game.player_name = ""
        expect(game).to_not be_valid
      end

      it "is not valid with player name empty string" do
        game.player_name = nil
        expect(game).to_not be_valid
      end
    end
  end

  context ": active frame" do
    it "should have status active is slot-1 & slot-2 is not nill or sum of slot-1 & slot-2 < 10" do
      active_frame = game.active_frame
      expect(active_frame.status).to eql("active")
    end

    it "should have status completed if is slot-1 & slot-2 is not nill and sum of slot-1 & slot-2 < 10" do
      active_frame = game.active_frame
      active_frame.add_score(score: 5)
      active_frame.add_score(score: 4)

      expect(active_frame.status).to eql("completed")
    end

    it "should have status completed if is slot-1 = 10" do
      active_frame = game.active_frame
      active_frame.add_score(score: 10)

      expect(active_frame.status).to eql("completed")
    end
  end

  context ": example" do
    it "with total score" do
      # 1st frame
      game.add_score(score: 8)
      game.add_score(score: 2)

      # 2nd frame
      game.add_score(score: 7)
      game.add_score(score: 3) 

      # 3rd frame
      game.add_score(score: 3)
      game.add_score(score: 4)       

      # 4th frame
      game.add_score(score: 10)

      # 5th frame
      game.add_score(score: 2)  
      game.add_score(score: 8)   
 
      # 6th frame
      game.add_score(score: 10)
  
      # 7th frame
      game.add_score(score: 10)

      # 8th frame
      game.add_score(score: 8)
      game.add_score(score: 0)

      # 9th frame
      game.add_score(score: 10)

      # 10th frame
      game.add_score(score: 8)
      game.add_score(score: 2)
      game.add_score(score: 9)

      expect(game.total_score).to eql(170)
    end
  end
end

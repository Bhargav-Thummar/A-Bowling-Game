class Api::V1::GamesController < ApplicationController
  before_action :current_game, only: [:add_score]

  def index
    render(json: Game.all, each_serializer: GameSerializer)
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      set_current_game

      render(
        json: { message: "Congratulation #{@game.player_name}!, You can start game"}, 
      )

    else
      render(
        json: 
          { 
            error: @game.errors.full_messages 
          }, 
        status: :unprocessable_entity
      )
    end
  end

  def add_score
  end

  private

    def set_current_game
      session[:game_id] = @game.id
    end

    def game_params
      params.require(:game).permit(:player_name)
    end
end

class Api::V1::GamesController < ApplicationController
  before_action :current_game, only: %i[add_score get_score_card]

  def index
    render(json: Game.all, each_serializer: GameSerializer)
  end

  def get_score_card
    render(json: current_game, serializer: GameSerializer)
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      set_current_game
      render(
        json: { message: "Congratulation #{@game.player_name}!, You can start game" }
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
    frame = current_game.add_score(score: score_params[:score]&.to_i)

    if frame.errors.any?
      render(
        json:
          {
            error: frame.errors.full_messages
          },
        status: :unprocessable_entity
      )
    else
      render(json: current_game, serializer: GameSerializer)
    end
  end

  private

  def set_current_game
    session[:game_id] = @game.id
  end

  def game_params
    params.require(:game).permit(:player_name)
  end

  def score_params
    params.require(:frame).permit(:score)
  end
end

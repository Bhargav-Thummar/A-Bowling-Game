class ApplicationController < ActionController::API
  def current_game
    @current_game = Game.find(session[:game_id])
  end
end

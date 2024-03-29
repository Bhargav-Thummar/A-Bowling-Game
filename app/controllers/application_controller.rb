class ApplicationController < ActionController::API
  # catch an exceptions
  include Errors::ErrorHandler

  def current_game
    @current_game = Game.find(session[:game_id])
  end
end

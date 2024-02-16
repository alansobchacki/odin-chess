require_relative "board"
require "colorize"

class Game
  def initialize
    @chess_board = Board.new
  end

  def game_start
    @chess_board.display_board
  end
end

game = Game.new
game.game_start

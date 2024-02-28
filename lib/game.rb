require_relative "board"
require_relative "announcements"
require_relative "pawn"
require_relative "rook"
require_relative "knight"
require_relative "king"
require "colorize"

class Game
  def initialize
    @chess_board = Board.new
    @display = Announcements.new
  end

  def start
    @display.greetings
    @chess_board.create_board
    @chess_board.setup_pieces
    play
  end

  def play
    # change this into a loop with an exit clause later on
    # currently set at a specific movement count for testing purposes only
    40.times do
      @display.player_one
      @chess_board.update_board
      @display.player_two
      @chess_board.move_square_selector
    end
  end
end

game = Game.new
game.start

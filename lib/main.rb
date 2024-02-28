require_relative 'board'
require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'king'
require_relative 'bishop'
require_relative 'queen'
require 'colorize'

class Main
  def initialize
    @chess_board = Board.new
    @checkmate = false
  end

  def start
    @chess_board.create_board
    @chess_board.setup_pieces
    play
  end

  def play
    loop do
      display_board_and_messages
      @chess_board.move_square_selector
      break if checkmate?
    end

    game_over if checkmate?
  end

  def display_board_and_messages
    puts '  Player One'.light_cyan
    puts ''

    @chess_board.update_board

    puts ''
    puts '  Player Two'.magenta
    check?
  end

  def check?
    8.times do |i|
      8.times do |j|
        if @chess_board.board[i][j][:piece]&.include?('king') && !@chess_board.board[i][j][:targeted_by].nil?
          puts ''
          puts '  Check!'
        end
      end
    end
  end

  def checkmate?
    checkmate = 0

    8.times do |i|
      8.times do |j|
        checkmate += 1 if @chess_board.board[i][j][:piece]&.include?('king')
      end
    end

    @checkmate = true if checkmate < 2
  end

  def game_over
    @chess_board.update_board
    puts ''
    puts '  Checkmate! The game is over!'
  end
end

game = Main.new
game.start

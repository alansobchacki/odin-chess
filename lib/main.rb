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
    @player_one = ''
    @player_two = ''
    @winner = ''
    @checkmate = false
    @check = false
  end

  def greetings
    puts '  Hello and welcome to my amazingly coded game of chess!'
    puts '  Player one, you go first! You control the ' << 'blue '.cyan << 'pieces. Please enter your name:'
    @player_one = gets.chomp.to_s[0, 20]
    puts '  Player two, how about you? You control the ' << 'purple '.magenta << 'pieces. Please enter your name:'
    @player_two = gets.chomp.to_s[0, 20]
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
    puts "  #{@player_one}".cyan
    puts ''
    @chess_board.update_board
    puts ''
    puts "  #{@player_two}".magenta
    check?
    @check == true ? display_check : display_instructions
  end

  def display_instructions
    puts ''
    puts "  Use WASD keys to select your piece, then press 'Enter' to confirm your choice."
    puts "  'W' Moves up - 'A' Moves left - 'S' Moves down - 'D' - Moves right"
  end

  def check?
    @check = false

    8.times do |i|
      8.times do |j|
        if @chess_board.board[i][j][:piece]&.include?('king') && !@chess_board.board[i][j][:targeted_by].nil?
          @check = true
        end
      end
    end
  end

  def display_check
    puts ''
    puts '  Check!'
  end

  def checkmate?
    checkmate = 0

    8.times do |i|
      8.times do |j|
        checkmate += 1 if @chess_board.board[i][j][:piece]&.include?('king')
      end
    end

    @checkmate = true if checkmate < 2
    decide_winner if @checkmate
  end

  def decide_winner
    8.times do |i|
      8.times do |j|
        @winner = @player_one if @chess_board.board[i][j][:piece] == 'white_king'
        @winner = @player_two if @chess_board.board[i][j][:piece] == 'black_king'
      end
    end
  end

  def game_over
    @chess_board.update_board
    puts ''
    puts '  Checkmate! The game is over!'
    @winner == @player_one ? (puts "  #{@player_one}".cyan << ' wins!') : (puts "  #{@player_two}".magenta << ' wins!')
  end
end

game = Main.new
game.greetings
game.start


# Allow pawns to move 2 squares if its their first move
# Show an array of captured pieces besides each player's name
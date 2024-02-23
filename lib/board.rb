require 'io/console'
require 'colorize'

# Everything board related (building our board, displaying its contents, choosing playable square) goes here.
class Board
  attr_accessor :board, :row, :col

  def initialize
    @board = []
    @row = 0
    @col = 0
    @pawn = WhitePawn.new(self)
  end

  # We create an array with 8 nested arrays, each containing 8 empty 'squares'.
  # This simulates an 8x8 board of chess
  # and our first square is currently our selected square
  def create_board
    8.times do |i|
      nested_row = []
      8.times do |j|
        if i.even?
          nested_row << (j.even? ? add_square('yellow') : add_square('light_yellow'))
        else
          nested_row << (j.odd? ? add_square('yellow') : add_square('light_yellow'))
        end
      end
      @board << nested_row
    end
    @board[0][0][:current_square] = true
  end

  # These are the squares we add to our board.
  # By default, they're empty.
  def add_square(color)
    {
      'color': color,
      'current_square': false,
      'id': nil,
      'contents': '   '
    }
  end

  # After that, we place our chess contentss on our board
  def setup_pieces
    8.times do |i|
      @board[1][i][:contents] = ' ♟ '.light_black
      @board[1][i][:id] = 'pawn_white'
      @board[6][i][:contents] = ' ♟ '.black
      @board[6][i][:id] = 'pawn_black'
    end
  end

  # And finally, our board is displayed on the terminal
  def update_board
    8.times do |i|
      print '  '
      8.times do |j|
        print_squares(i, j)
      end
      puts "\e[0m" # Returns our default background color to black
    end
  end

  def print_squares(row, col)
    square = @board[row][col]

    if square[:current_square]
      print square[:contents].on_light_cyan
    elsif square[:color] == 'yellow'
      print square[:contents].on_yellow
    elsif square[:color] == 'light_yellow'
      print square[:contents].on_light_yellow
    end
  end

  # Then, we pick which board square we want to play with
  def move_square_selector
    movement = $stdin.getch.upcase
    case movement
    when 'W' then move(-1, 0)  # Up
    when 'A' then move(0, -1)  # Left
    when 'S' then move(1, 0)   # Down
    when 'D' then move(0, 1)   # Right
    when "\r" then select_square # Enter
    end
  end

  def move(row_change, col_change)
    puts "\e[H\e[2J" # Resets our terminal input
    new_row = @row + row_change
    new_col = @col + col_change

    return unless new_row.between?(0, 7) && new_col.between?(0, 7)

    @board[new_row][new_col][:current_square] = true
    @board[@row][@col][:current_square] = false
    @row = new_row
    @col = new_col
  end

  def select_square
    puts "\e[H\e[2J" # Resets our terminal input
    square = @board[@row][@col][:id]

    square&.include?('pawn_white') && @pawn&.can_move?(@row, @col)
  end
end

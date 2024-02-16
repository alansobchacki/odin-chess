require 'io/console'
require 'colorize'

class Board
  def initialize
    create_board
    setup_pieces
  end

  # we create an array with 8 nested arrays, each containing 8 empty 'squares'
  # this simulates an 8x8 board of chess
  def create_board
    @board = []
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
  end

  # these are the squares we add to our board
  def add_square(color)
    {
      'color': color,
      'piece': '   '
    }
  end

  # after that, we place our chess pieces in our board
  def setup_pieces
    8.times do |i|
      @board[1][i][:piece] = ' ♙ '.white
      @board[6][i][:piece] = ' ♙ '.black
    end
  end

  # and finally, our board is displayed on the terminal
  def display_board
    puts "\e[H\e[2J" # resets our terminal input

    8.times do |i|
      print '  '
      8.times do |j|
        print_squares(i, j)
      end
      puts "\e[0m" # returns our default background color to black
    end
  end

  def print_squares(row, col)
    if @board[row][col][:color] == 'yellow'
      print @board[row][col][:piece].on_yellow
    elsif @board[row][col][:color] == 'light_yellow'
      print @board[row][col][:piece].on_light_yellow
    end
  end
end

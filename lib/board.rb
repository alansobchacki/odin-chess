require 'io/console'
require 'colorize'

class Board
  def initialize
    create_board
    @board[0][0] = '   '.on_light_black
    @row = 0
    @col = 0
  end

  def create_board
    @board = []
    8.times do |i|
      nested_row = []
      8.times do |j|
        if i.even?
          nested_row << (j.even? ? '   '.on_light_green : '   '.on_light_yellow)
        else
          nested_row << (j.odd? ? '   '.on_light_green : '   '.on_light_yellow)
        end
      end
      @board << nested_row
    end
  end

  def display_board
    puts "\e[H\e[2J"

    8.times do |i|
      8.times do |j|
        print @board[i][j]
      end
      puts ''
    end

    move_selection
  end

  def move_selection
    movement = STDIN.getch.upcase
    case movement
    when 'S' then move_down
    when 'W' then move_up
    when 'A' then move_left
    when 'D' then move_right
    end
  end

  def move_down
    if @row < 7
      update_square_color
      @row += 1
      @board[@row][@col] = '   '.on_light_black
    end

    display_board
  end

  def move_up
    if @row.positive?
      update_square_color
      @row -= 1
      @board[@row][@col] = '   '.on_light_black
    end

    display_board
  end

  def move_right
    if @col < 7
      update_square_color
      @col += 1
      @board[@row][@col] = '   '.on_light_black
    end

    display_board
  end

  def move_left
    if @col.positive?
      update_square_color
      @col -= 1
      @board[@row][@col] = '   '.on_light_black
    end

    display_board
  end

  def update_square_color
    color = (@row + @col).even? ? '   '.on_light_green : '   '.on_light_yellow
    @board[@row][@col] = color
  end
end

board = Board.new
board.display_board

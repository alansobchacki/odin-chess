require 'io/console'
require 'colorize'

# Everything board related (building our board, displaying its contents, choosing playable square) goes here.
class Board
  attr_accessor :board, :row, :col

  def initialize
    @board = []
    @row = 0
    @col = 0
    create_pieces
  end

  def create_pieces
    @white_pawn = WhitePawn.new(self)
    @black_pawn = BlackPawn.new(self)
    @white_rook = Rook.new(self)
  end

  # First, we build a nested array of 8 arrays, with each array holding a hash value
  # This allows for powerful customization of pieces and easy board coordinates positioning
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

  def add_square(color)
    {
      'color': color,
      'current_square': false,
      'targeted_by': nil,
      'belongs_to': nil,
      'piece': nil,
      'id': nil,
      'contents': '   '
    }
  end

  # After that, we place our chess pieces on the board
  def setup_pieces
    place_pawns
    place_rooks
    # place_knights
    # place_bishops
    # place_queens
    # place_kings
  end

  def place_pieces(row, col, contents, belongs_to, piece, id)
    @board[row][col][:contents] = contents
    @board[row][col][:belongs_to] = belongs_to
    @board[row][col][:piece] = piece
    @board[row][col][:id] = id
  end

  def place_pawns
    8.times do |i|
      place_pieces(1, i, ' ♟ '.light_black, 'player_one', 'white_pawn', i)
      place_pieces(6, i, ' ♟ '.black, 'player_two', 'black_pawn', i)
    end
  end

  def place_rooks
    place_pieces(0, 0, ' ♜ '.light_black, 'player_one', 'white_rook', 1)
    place_pieces(0, 7, ' ♜ '.light_black, 'player_one', 'white_rook', 2)
    place_pieces(7, 0, ' ♜ '.black, 'player_two', 'black_rook', 1)
    place_pieces(7, 7, ' ♜ '.black, 'player_two', 'black_rook', 2)
  end

  def place_knights
    place_pieces(0, 1, ' ♞ '.light_black, 'player_one', 'white_knight', 1)
    place_pieces(0, 6, ' ♞ '.light_black, 'player_one', 'white_knight', 2)
    place_pieces(7, 1, ' ♞ '.black, 'player_two', 'black_knight', 1)
    place_pieces(7, 6, ' ♞ '.black, 'player_two', 'black_knight', 2)
  end

  def place_bishops
    place_pieces(0, 2, ' ♝ '.light_black, 'player_one', 'white_bishop', 1)
    place_pieces(0, 5, ' ♝ '.light_black, 'player_one', 'white_bishop', 2)
    place_pieces(7, 2, ' ♝ '.black, 'player_two', 'black_bishop', 1)
    place_pieces(7, 5, ' ♝ '.black, 'player_two', 'black_bishop', 2)
  end

  def place_queens
    place_pieces(0, 3, ' ♛ '.light_black, 'player_one', 'white_queen', 1)
    place_pieces(7, 3, ' ♛ '.black, 'player_two', 'black_queen', 1)
  end

  def place_kings
    place_pieces(0, 4, ' ♛ '.light_black, 'player_one', 'white_king', 1)
    place_pieces(7, 4, ' ♚ '.black, 'player_two', 'black_king', 1)
  end

  # And finally, our board can be displayed on the terminal
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
    elsif !square[:targeted_by].nil?
      print square[:contents].on_green
    elsif square[:color] == 'yellow'
      print square[:contents].on_yellow
    elsif square[:color] == 'light_yellow'
      print square[:contents].on_light_yellow
    end
  end

  # The board is already all set up, so now we can interact with it
  # We pick which board square we want to play with
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

    @black_pawn.move?(@row, @col)
    @white_pawn.move?(@row, @col)
    @white_rook.move?(@row, @col)
  end
end

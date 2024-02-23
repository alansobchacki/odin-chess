require 'colorize'

class WhitePawn
  def initialize(board)
    @board = board
  end

  def can_move?(row, col)
    if @board.board[row][col][:id] == 'pawn_white'
      show_viable_squares(row, col)
    elsif @board.board[row][col][:id] == 'pawn_white_can_move'
      move_pawn(row, col)
    end
  end

  def show_viable_squares(row, col)
    @board.board[row + 1][col][:id] = 'pawn_white_can_move'
    @board.board[row + 1][col][:contents] = ' O '.gray
  end

  def move_pawn(row, col)
    @board.board[row - 1][col][:contents] = '   '
    @board.board[row][col][:id] = 'pawn_white'
    @board.board[row][col][:contents] = ' ♟ '.light_black
  end
end

# chess pieces symbols:
# ♜  ♞  ♝  ♛  ♚  ♟
#######################

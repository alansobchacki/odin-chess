require 'colorize'

class WhitePawn
  def initialize(board)
    @board = board
    @attacking_pawn_id = nil
  end

  def move?(row, col)
    square = @board.board[row][col]
    pawn_id = @board.board[row][col][:id]

    if !square[:targeted_by].nil?
      capture?(row, col, @attacking_pawn_id)
    elsif square[:piece] == 'white_pawn'
      show_viable_captures(row, col)
      show_viable_movement(row, col, pawn_id) if @board.board[row + 1][col][:id].nil?
    elsif square[:piece] == 'moveable_white_pawn'
      move_pawn(row, col, pawn_id)
    end
  end

  def show_viable_movement(row, col, pawn_id)
    # write a method to prevent things from crashing if a piece tries to move out from the allowed array range (0-7)
    @board.board[row + 1][col][:piece] = 'moveable_white_pawn'
    @board.board[row + 1][col][:id] = pawn_id
    @board.board[row + 1][col][:contents] = ' X '.gray
  end

  def move_pawn(row, col, pawn_id)
    pick_up_pawn(pawn_id)
    place_pawn(row, col, pawn_id)
  end

  def pick_up_pawn(pawn_id)
    8.times do |i|
      8.times do |j|
        if @board.board[i][j][:piece] == 'white_pawn' && @board.board[i][j][:id] == pawn_id
          @board.board[i][j][:piece] = nil
          @board.board[i][j][:targeted_by] = nil
          @board.board[i][j][:contents] = '   '
        end
      end
    end
  end

  def place_pawn(row, col, pawn_id)
    @board.board[row][col][:piece] = 'white_pawn'
    @board.board[row][col][:id] = pawn_id
    @board.board[row][col][:targeted_by] = nil
    @board.board[row][col][:contents] = ' ♟ '.light_black
  end

  def show_viable_captures(row, col)
    @attacking_pawn_id = @board.board[row][col][:id]
    # write a method to prevent pieces from being captured by their own color
    # you're only checking for nil - also check for player id
    @board.board[row + 1][col + 1][:targeted_by] = 'white_pawn' unless @board.board[row + 1][col + 1][:id].nil?
    @board.board[row + 1][col - 1][:targeted_by] = 'white_pawn' unless @board.board[row + 1][col - 1][:id].nil?
  end

  def capture?(row, col, attacking_pawn)
    move_pawn(row, col, attacking_pawn)
    # write a method to reset all targeted squares to their default color
  end
end

# chess pieces symbols:
# ♜  ♞  ♝  ♛  ♚  ♟
#######################
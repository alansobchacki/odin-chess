require 'colorize'

class WhitePawn
  def initialize(board)
    @board = board
    @attacking_pawn_id = nil
  end

  def move?(row, col)
    return if @board.board[row][col][:targeted_by]&.include?('black')

    square = @board.board[row][col]
    pawn_id = @board.board[row][col][:id]

    if square[:targeted_by] == 'white_pawn'
      capture?(row, col, @attacking_pawn_id)
    elsif square[:piece] == 'white_pawn'
      show_viable_captures(row, col) if row < 7
      show_viable_movement(row, col, pawn_id) if row < 7
    elsif square[:piece] == 'moveable_white_pawn'
      move_pawn(row, col, pawn_id)
    end
  end

  def show_viable_movement(row, col, pawn_id)
    return unless @board.board[row + 1][col][:id].nil?

    @board.board[row + 1][col][:piece] = 'moveable_white_pawn'
    @board.board[row + 1][col][:id] = pawn_id
    @board.board[row + 1][col][:contents] = ' X '.gray
  end

  def move_pawn(row, col, pawn_id)
    pick_up_pawn(pawn_id)
    place_pawn(row, col, pawn_id)
    reset_targeted_pieces
  end

  def pick_up_pawn(pawn_id)
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'white_pawn' && @board.board[i][j][:id] == pawn_id

        remove_movement_squares(i, j)
      end
    end
  end

  def place_pawn(row, col, pawn_id)
    @board.board[row][col][:piece] = 'white_pawn'
    @board.board[row][col][:belongs_to] = 'player_one'
    @board.board[row][col][:id] = pawn_id
    @board.board[row][col][:contents] = ' ♟ '.light_black
  end

  def show_viable_captures(row, col)
    @attacking_pawn_id = @board.board[row][col][:id]

    if (col + 1) < 7 && @board.board[row + 1][col + 1][:belongs_to] == 'player_two'
      @board.board[row + 1][col + 1][:targeted_by] = 'white_pawn'
    end

    if (col - 1) >= 0 && @board.board[row + 1][col - 1][:belongs_to] == 'player_two'
      @board.board[row + 1][col - 1][:targeted_by] = 'white_pawn'
    end
  end

  def capture?(row, col, attacking_pawn)
    move_pawn(row, col, attacking_pawn)
    reset_targeted_pieces
    reset_movements
  end

  def reset_targeted_pieces
    8.times do |i|
      8.times do |j|
        @board.board[i][j][:targeted_by] = nil unless @board.board[i][j][:targeted_by].nil?
      end
    end
  end

  def reset_movements
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'moveable_white_pawn'

        remove_movement_squares(i, j)
      end
    end
  end

  def remove_movement_squares(row, col)
    @board.board[row][col][:piece] = nil
    @board.board[row][col][:targeted_by] = nil
    @board.board[row][col][:belongs_to] = nil
    @board.board[row][col][:id] = nil
    @board.board[row][col][:contents] = '   '
  end
end

# chess pieces symbols:
# ♜  ♞  ♝  ♛  ♚  ♟
#######################
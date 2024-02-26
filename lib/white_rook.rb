require 'colorize'

class WhiteRook
  def initialize(board)
    @board = board
    @attacking_rook_id = nil
  end

  def move?(row, col)
    return if @board.board[row][col][:targeted_by]&.include?('black')

    square = @board.board[row][col]
    rook_id = @board.board[row][col][:id]

    if !square[:targeted_by].nil?
      capture?(row, col, @attacking_rook_id)
    elsif square[:piece] == 'white_rook'
      show_viable_captures(row, col) if row < 7
      show_viable_movement(row, col, rook_id) if row < 7
    elsif square[:piece] == 'moveable_white_rook'
      move_rook(row, col, rook_id)
    end
  end

  def show_viable_movement(row, col, rook_id)
    return unless @board.board[row + 1][col][:id].nil?

    @board.board[row + 1][col][:piece] = 'moveable_white_rook'
    @board.board[row + 1][col][:id] = rook_id
    @board.board[row + 1][col][:contents] = ' X '.gray
  end

  def move_rook(row, col, rook_id)
    pick_up_rook(rook_id)
    place_rook(row, col, rook_id)
  end

  def pick_up_rook(rook_id)
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'white_rook' && @board.board[i][j][:id] == rook_id

        @board.board[i][j][:piece] = nil
        @board.board[i][j][:targeted_by] = nil
        @board.board[i][j][:belongs_to] = nil
        @board.board[i][j][:id] = nil
        @board.board[i][j][:contents] = '   '
      end
    end
  end

  def place_rook(row, col, rook_id)
    @board.board[row][col][:piece] = 'white_rook'
    @board.board[row][col][:belongs_to] = 'player_one'
    @board.board[row][col][:id] = rook_id
    @board.board[row][col][:contents] = ' ♟ '.light_black
  end

  def show_viable_captures(row, col)
    @attacking_rook_id = @board.board[row][col][:id]

    if (col + 1) < 7 && @board.board[row + 1][col + 1][:belongs_to] == 'player_two'
      @board.board[row + 1][col + 1][:targeted_by] = 'white_rook'
    end

    if (col - 1) >= 0 && @board.board[row + 1][col - 1][:belongs_to] == 'player_two'
      @board.board[row + 1][col - 1][:targeted_by] = 'white_rook'
    end
  end

  def capture?(row, col, attacking_rook)
    move_rook(row, col, attacking_rook)
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

  # rewrite this to avoid DRY
  def reset_movements
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'moveable_white_rook'

        @board.board[i][j][:piece] = nil
        @board.board[i][j][:targeted_by] = nil
        @board.board[i][j][:belongs_to] = nil
        @board.board[i][j][:id] = nil
        @board.board[i][j][:contents] = '   '
      end
    end
  end
end

# chess pieces symbols:
# ♜  ♞  ♝  ♛  ♚  ♟
#######################
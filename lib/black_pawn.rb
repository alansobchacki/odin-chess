require 'colorize'

class BlackPawn
  def initialize(board)
    @board = board
    @attacking_pawn_id = nil
  end

  def move?(row, col)
    return if @board.board[row][col][:targeted_by]&.include?('white')

    square = @board.board[row][col]
    pawn_id = @board.board[row][col][:id]

    if !square[:targeted_by].nil?
      capture?(row, col, @attacking_pawn_id)
    elsif square[:piece] == 'black_pawn'
      show_viable_captures(row, col) if row.positive?
      show_viable_movement(row, col, pawn_id) if row.positive?
    elsif square[:piece] == 'moveable_black_pawn'
      move_pawn(row, col, pawn_id)
    end
  end

  def show_viable_movement(row, col, pawn_id)
    return unless @board.board[row - 1][col][:id].nil?

    @board.board[row - 1][col][:piece] = 'moveable_black_pawn'
    @board.board[row - 1][col][:id] = pawn_id
    @board.board[row - 1][col][:contents] = ' X '.gray
  end

  def move_pawn(row, col, pawn_id)
    pick_up_pawn(pawn_id)
    place_pawn(row, col, pawn_id)
  end

  def pick_up_pawn(pawn_id)
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'black_pawn' && @board.board[i][j][:id] == pawn_id

        @board.board[i][j][:piece] = nil
        @board.board[i][j][:targeted_by] = nil
        @board.board[i][j][:belongs_to] = nil
        @board.board[i][j][:id] = nil
        @board.board[i][j][:contents] = '   '
      end
    end
  end

  def place_pawn(row, col, pawn_id)
    @board.board[row][col][:piece] = 'black_pawn'
    @board.board[row][col][:belongs_to] = 'player_two'
    @board.board[row][col][:id] = pawn_id
    @board.board[row][col][:contents] = ' ♟ '.black
  end

  def show_viable_captures(row, col)
    @attacking_pawn_id = @board.board[row][col][:id]

    if (col + 1) < 7 && @board.board[row - 1][col + 1][:belongs_to] == 'player_one'
      @board.board[row - 1][col + 1][:targeted_by] = 'black_pawn'
    end

    if (col - 1) >= 0 && @board.board[row - 1][col - 1][:belongs_to] == 'player_one'
      @board.board[row - 1][col - 1][:targeted_by] = 'black_pawn'
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

  # rewrite this to avoid DRY
  def reset_movements
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'moveable_black_pawn'

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
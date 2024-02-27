require 'colorize'

class Rook
  def initialize(board)
    @board = board
    @attacking_rook_id = nil
  end

  def move?(row, col)
    return if @board.board[row][col][:targeted_by]&.include?('black')

    square = @board.board[row][col]
    rook_id = @board.board[row][col][:id]

    if square[:targeted_by] == 'white_rook'
      capture?(row, col, @attacking_rook_id)
    elsif square[:piece] == 'white_rook'
      show_viable_movement(row, col, rook_id)
    elsif square[:piece] == 'moveable_white_rook'
      move_rook(row, col, rook_id)
    end
  end

  # write a logic to make loops so that your rook can move to all vertical and horizontal squares
  def show_viable_movement(row, col, rook_id)
    rook_right_movements(row, col, rook_id)
    rook_left_movements(row, col, rook_id)
    rook_bottom_movements(row, col, rook_id)
    rook_top_movements(row, col, rook_id)
  end

  def rook_right_movements(row, col, rook_id)
    8.times do |i|
      break if (col + i) >= 8
      next if col == (col + i)
      if @board.board[row][col + i][:piece].is_a?(String) && @board.board[row][col + i][:current_square] == false
        if @board.board[row][col + i][:belongs_to] == 'player_two'
          @attacking_rook_id = rook_id
          @board.board[row][col + i][:targeted_by] = 'white_rook'
        end
        break
      end

      @board.board[row][col + i][:piece] = 'moveable_white_rook'
      @board.board[row][col + i][:contents] = ' X '.gray
      @board.board[row][col + i][:id] = rook_id
    end
  end

  def rook_left_movements(row, col, rook_id)
    8.times do |i|
      break if (col - i).negative?
      break if @board.board[row][col - i][:piece].is_a?(String) && @board.board[row][col - i][:current_square] == false
      next if col == (col - i)

      @board.board[row][col - i][:piece] = 'moveable_white_rook'
      @board.board[row][col - i][:contents] = ' X '.gray
      @board.board[row][col - i][:id] = rook_id
    end
  end

  def rook_bottom_movements(row, col, rook_id)
    8.times do |i|
      break if (row + i) >= 8
      break if @board.board[row + i][col][:piece].is_a?(String) && @board.board[row + i][col][:current_square] == false
      next if row == (row + i)

      @board.board[row + i][col][:piece] = 'moveable_white_rook'
      @board.board[row + i][col][:contents] = ' X '.gray
      @board.board[row + i][col][:id] = rook_id
    end
  end

  def rook_top_movements(row, col, rook_id)
    8.times do |i|
      break if (row - i).negative?
      break if @board.board[row - i][col][:piece].is_a?(String) && @board.board[row - i][col][:current_square] == false
      next if row == (row - i)

      @board.board[row - i][col][:piece] = 'moveable_white_rook'
      @board.board[row - i][col][:contents] = ' X '.gray
      @board.board[row - i][col][:id] = rook_id
    end
  end

  def move_rook(row, col, rook_id)
    pick_up_rook(rook_id)
    place_rook(row, col, rook_id)
    reset_movements
    reset_targeted_pieces
  end

  def pick_up_rook(rook_id)
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'white_rook' && @board.board[i][j][:id] == rook_id

        remove_movement_squares(i, j)
      end
    end
  end

  def place_rook(row, col, rook_id)
    @board.board[row][col][:piece] = 'white_rook'
    @board.board[row][col][:belongs_to] = 'player_one'
    @board.board[row][col][:id] = rook_id
    @board.board[row][col][:contents] = ' ♜ '.light_black
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

  def reset_movements
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == 'moveable_white_rook'

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
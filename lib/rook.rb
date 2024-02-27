require 'colorize'

class Rook
  def initialize(board, piece, moving_piece, player, enemy_player, enemy_player_color)
    @board = board
    @piece = piece
    @moving_piece = moving_piece
    @player = player
    @enemy_player = enemy_player
    @enemy_player_color = enemy_player_color
    @attacking_rook_id = nil
  end

  def move?(row, col)
    return if @board.board[row][col][:targeted_by]&.include?(@enemy_player_color)

    square = @board.board[row][col]
    rook_id = @board.board[row][col][:id]

    if square[:targeted_by] == @piece
      capture?(row, col, @attacking_rook_id)
    elsif square[:piece] == @piece
      show_viable_movement(row, col, rook_id)
    elsif square[:piece] == @moving_piece
      move_rook(row, col, rook_id)
    end
  end

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
        if @board.board[row][col + i][:belongs_to] == @enemy_player
          @attacking_rook_id = rook_id
          @board.board[row][col + i][:targeted_by] = @piece
        end
        break
      end

      @board.board[row][col + i][:piece] = @moving_piece
      @board.board[row][col + i][:contents] = ' X '.gray
      @board.board[row][col + i][:id] = rook_id
    end
  end

  def rook_left_movements(row, col, rook_id)
    8.times do |i|
      break if (col - i).negative?
      next if col == (col - i)

      if @board.board[row][col - i][:piece].is_a?(String) && @board.board[row][col - i][:current_square] == false
        if @board.board[row][col - i][:belongs_to] == @enemy_player
          @attacking_rook_id = rook_id
          @board.board[row][col - i][:targeted_by] = @piece
        end
        break
      end

      @board.board[row][col - i][:piece] = @moving_piece
      @board.board[row][col - i][:contents] = ' X '.gray
      @board.board[row][col - i][:id] = rook_id
    end
  end

  def rook_bottom_movements(row, col, rook_id)
    8.times do |i|
      break if (row + i) >= 8
      next if row == (row + i)

      if @board.board[row + i][col][:piece].is_a?(String) && @board.board[row + i][col][:current_square] == false
        if @board.board[row + i][col][:belongs_to] == @enemy_player
          @attacking_rook_id = rook_id
          @board.board[row + i][col][:targeted_by] = @piece
        end
        break
      end

      @board.board[row + i][col][:piece] = @moving_piece
      @board.board[row + i][col][:contents] = ' X '.gray
      @board.board[row + i][col][:id] = rook_id
    end
  end

  def rook_top_movements(row, col, rook_id)
    8.times do |i|
      break if (row - i).negative?
      next if row == (row - i)

      if @board.board[row - i][col][:piece].is_a?(String) && @board.board[row - i][col][:current_square] == false
        if @board.board[row - i][col][:belongs_to] == @enemy_player
          @attacking_rook_id = rook_id
          @board.board[row - i][col][:targeted_by] = @piece
        end
        break
      end

      @board.board[row - i][col][:piece] = @moving_piece
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
        next unless @board.board[i][j][:piece] == @piece && @board.board[i][j][:id] == rook_id

        remove_movement_squares(i, j)
      end
    end
  end

  def place_rook(row, col, rook_id)
    @board.board[row][col][:piece] = @piece
    @board.board[row][col][:belongs_to] = @player
    @board.board[row][col][:id] = rook_id

    if @player == 'player_one' then
      @board.board[row][col][:contents] = ' ♜ '.light_black
    else
      @board.board[row][col][:contents] = ' ♜ '.black
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

  def reset_movements
    8.times do |i|
      8.times do |j|
        next unless @board.board[i][j][:piece] == @moving_piece

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
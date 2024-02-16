require 'colorize'

class Pawn
  def initialize
    @visuals = "\u2659"
  end

  def to_s
    " \u265F ".white
  end
end

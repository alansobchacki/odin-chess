require 'io/console'
require 'colorize'

class Announcements
  def greetings
    # make something more fancy later on
    puts 'Welcome to Chess!'
  end

  def player_one
    # replace colors with something better later on
    puts '  Player One'.light_cyan
    puts ''
  end

  def player_two
    # replace colors with something better later on
    puts ''
    puts '  Player Two'.magenta
  end
end

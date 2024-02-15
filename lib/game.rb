require 'colorize'

String.colors.each do |color|
  puts "This is #{color}".colorize(color.to_sym)
end

# frozen_string_literal: true

require_relative 'lib/game'

puts "\n" * 50
puts 'Welcome to Mastermind.'
rounds = nil
until rounds
  puts "\nHow many rounds would you like to play?"
  input = gets.chomp.to_i
  rounds = input if [1, 2, 3].include? input
end

difficulty = nil
until difficulty
  puts "\n" * 50
  puts "\nWhat difficulty would you like to play?\n\nEasy, normal, or hard?"
  input = gets.chomp.to_sym
  difficulty = input if %i[easy normal hard].include? input
end
puts "\n" * 50

game = Game.new(difficulty, rounds)
game.play

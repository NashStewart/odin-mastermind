# frozen_string_literal: true

require_relative 'lib/game'

puts "\n" * 50
puts "Welcome to Mastermind.\n\nThe game has two phases:"
puts "  1. Guess the computer's code in as few guesses as possible."
puts '  2. Write a code that is difficult for the computer to crack.'
puts "\nThe code maker will score points according to the number of turns the codebreaker takes to crack the code."
puts 'At the end of the final round, whoever scored the most points wins the game.'

rounds = nil
until rounds
  puts "\nHow many rounds would you like to play?"
  input = gets.chomp.to_i
  rounds = input if [1, 2, 3].include? input
end

difficulty = nil
until difficulty
  puts "\n" * 50
  puts "\nWhat difficulty would you like to play?\n\nEASY, NORMAL, or HARD?"
  input = gets.chomp.downcase.to_sym
  difficulty = input if %i[easy normal hard].include? input
end
puts "\n" * 50

game = Game.new(difficulty, rounds)
game.play

point_difference = game.player_score - game.computer_score
lead = point_difference.abs
if point_difference.positive?
  puts "\nYou win by #{lead} points!"
elsif point_difference.negative?
  puts "\nComputer wins by #{lead} points!"
else
  puts "\nDraw! Nobody wins :("
end

puts 'Thanks for playing!'

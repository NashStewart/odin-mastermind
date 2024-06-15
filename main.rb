# frozen_string_literal: true

require_relative 'lib/round'

puts "Welcome to Mastermind.\nHow many rounds would you like to play?"
rounds = nil
until rounds
  input = gets.chomp.to_i
  rounds = input if [1, 2, 3].include? input
end

computer_score = 0
while rounds.positive?
  puts 'Press ENTER to continue'
  gets

  round = Round.new
  player_is_winner = round.play
  computer_score += round.score

  puts 'You cracked it!' if player_is_winner
  puts "Round score: #{round.score}"
  puts "Computer score: #{computer_score}"

  rounds -= 1
end

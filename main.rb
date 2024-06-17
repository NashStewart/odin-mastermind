# frozen_string_literal: true

require_relative 'lib/round'
require_relative 'lib/computer'

puts "Welcome to Mastermind.\nHow many rounds would you like to play?"
rounds = nil
until rounds
  input = gets.chomp.to_i
  rounds = input if [1, 2, 3].include? input
end

player_score = 0
computer_score = 0
while rounds.positive?
  puts 'Your turn.'
  puts 'Press ENTER to continue.'
  gets

  round = Round.new
  player_is_winner = round.play
  computer_score += round.score

  puts 'You cracked it!' if player_is_winner
  puts "Computer scores #{round.score} points this round."
  puts "Computer score: #{computer_score}"
  puts "Player score: #{player_score}"

  round = Round.new
  computer = Computer.new

  puts "\nComputer's turn."
  round.prompt_player_code
  puts 'Your code:'
  round.print_code round.code_colors
  puts "\nPress ENTER to continue."
  gets

  while computer.total_hits < 4
    guess = computer.guess
    feedback = round.guess(guess)
    hits = feedback[:full_matches] + feedback[:color_only_matches]
    computer.update_color_match(guess.first, hits)
  end

  puts
  computer.initialize_possible_codes

  until round.code_is_cracked || round.turns_taken == round.turns
    guess = computer.random_guess
    round.guess(guess)
  end

  round_score = round.code_is_cracked ? round.turns_taken : round.turns + 1
  player_score += round_score

  round.print
  round.print_code round.code_colors
  puts 'The computer cracked it!' if round.code_is_cracked
  puts "You score #{round_score} points this round."
  puts "Computer score: #{computer_score}"
  puts "Your score: #{player_score}"

  rounds -= 1
end

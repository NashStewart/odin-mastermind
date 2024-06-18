# frozen_string_literal: true

require_relative 'round'
require_relative 'computer'

# Object representing a game of Mastermind.
class Game
  attr_reader :player_score, :computer_score, :difficulty, :rounds

  def initialize(difficulty, rounds)
    @player_score = 0
    @computer_score = 0
    @difficulty = %i[easy normal hard].include?(difficulty) ? difficulty : :easy
    @rounds = [1, 2, 3].include?(rounds) ? rounds : 1
  end

  def play
    while rounds.positive?
      take_player_turn
      take_computer_turn
      @rounds -= 1
    end
  end

  def take_player_turn
    round = Round.new player_turns

    puts "\nYour turn.\n\nPress ENTER to continue."
    gets

    round.play
    @computer_score += round.final_score

    puts 'You cracked it!' if round.code_is_cracked
    puts "Computer scores #{round.final_score} points this round.\nComputer score: #{computer_score}"
    puts "Player score: #{player_score}\n\nPress ENTER to continue."
    gets
  end

  def player_turns
    case difficulty
    when :hard
      8
    when :normal
      10
    else
      12
    end
  end

  def take_computer_turn
    round = Round.new 12
    computer = Computer.new

    get_player_code round
    computer_figure_out_colors(computer, round)
    computer.initialize_possible_codes
    computer_guess_until_round_end(computer, round)

    @player_score += round.final_score
    print_computer_turn_summary round
  end

  def computer_figure_out_colors(computer, round)
    while computer.total_hits < 4
      guess = computer.guess
      feedback = round.guess(guess)
      hits = feedback[:full_matches] + feedback[:color_only_matches]
      computer.update_color_match(guess.first, hits)
    end
  end

  def computer_guess_until_round_end(computer, round)
    until round.code_is_cracked || round.turns_taken == round.turns
      guess = computer.random_guess
      round.guess(guess)
    end
  end

  def print_computer_turn_summary(round)
    round.print
    round.print_code round.code_colors
    puts 'The computer cracked it!' if round.code_is_cracked
    puts "You score #{round.final_score} points this round."
    puts "Computer score: #{computer_score}"
    puts "Your score: #{player_score}"
  end

  def get_player_code(round)
    puts "\n" * 50
    puts "Computer's turn.\nEnter a code.\n"
    round.prompt_player_code

    puts "\n" * 50
    round.print_code round.code_colors
    puts "\nPress ENTER to continue."
    gets
  end
end

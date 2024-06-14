# frozen_string_literal: true

require_relative 'printable'

# Object modeling the data and behavior of a round of Mastermind.
class Round
  include Printable

  attr_reader :code_colors, :colors, :guesses, :code_is_cracked, :possible_colors, :turns, :turns_taken

  def initialize
    @code_is_cracked = false
    @code_colors = Array.new 4
    @possible_colors = %i[red blue yellow green black white]
    @turns = 2
    @turns_taken = 0
    @guesses = Array.new(turns) { { colors: [], full_matches: 0, color_only_matches: 0 } }
  end

  def play
    generate_random_code
    take_turn until code_is_cracked || turns_taken == turns
    print
  end

  private

  def generate_random_code
    code_colors.each_with_index { |_, i| code_colors[i] = %i[red yellow blue green black white].sample }
    p code_colors
  end

  def take_turn
    @guesses[turns_taken][:colors] = Array.new 4
    choice_count = 0
    while choice_count < 4
      print_menu
      choice = player_choice
      next unless choice

      @guesses[turns_taken][:colors][choice_count] = choice
      choice_count += 1
    end
    guess(guesses[turns_taken][:colors])
  end

  def player_choice
    choice = gets.chomp.downcase.to_sym
    choice if possible_colors.include?(choice)
  end

  def guess(guess_colors)
    return unless turns_taken < turns
    
    @code_is_cracked = code_colors == guess_colors
    @guesses[turns_taken][:colors] = guess_colors.clone

    remaining_colors = record_full_matches(guess_colors)
    record_color_only_matches(remaining_colors, guess_colors)

    @turns_taken += 1
  end

  def print
    super(guesses, turns)
  end

  def print_menu
    print
    puts "\nEnter a color to choose:"
    menu = possible_colors.reduce('') do |options, color|
      color_str = color.to_s.capitalize
      options + "#{feedback_pip color}: #{color_str} "
    end
    puts menu
  end

  def record_full_matches(guess_colors)
    remaining_colors = code_colors.clone
    code_colors.each_with_index do |color, index|
      next unless color == guess_colors[index]

      @guesses[turns_taken][:full_matches] += 1
      remaining_colors[index] = nil
      guess_colors[index] = nil
    end
    remaining_colors
  end

  def record_color_only_matches(unmatched_colors, guess_colors)
    guess_colors.compact.each do |color|
      if unmatched_colors.include?(color)
        unmatched_colors.delete_at unmatched_colors.index(color)
        @guesses[turns_taken][:color_only_matches] += 1
      end
    end
  end
end

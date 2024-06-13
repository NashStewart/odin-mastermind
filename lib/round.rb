# frozen_string_literal: true

require_relative 'printable'

# Object modeling the data and behavior of a round of Mastermind.
class Round
  include Printable

  attr_reader :code_colors, :colors, :guesses, :turns, :turns_taken

  def initialize
    @code_colors = Array.new 4
    @turns = 12
    @turns_taken = 0
    @guesses = Array.new(turns) { { colors: [], full_matches: 0, color_only_matches: 0 } }
  end

  def generate_random_code
    code_colors.each_with_index { |_, i| code_colors[i] = %i[red yellow blue green black white].sample }
    # @code_colors = %i[red white green black]
    @code_colors = %i[green green blue black]
  end

  def play
    @guesses[turns_taken][:colors] = Array.new(4, :grey)
    @guesses[turns_taken][:colors][0] = :red
    return
    while turns_taken < turns
      print
      puts "Enter your guess"
    end 
  end

  def guess(guess_colors)
    return unless turns_taken < turns - 1

    @guesses[turns_taken][:colors] = guess_colors.clone

    remaining_colors = record_full_matches(guess_colors)
    record_color_only_matches(remaining_colors, guess_colors)

    @turns_taken += 1
    code_colors == guess_colors
  end

  def print
    super(guesses, turns)
  end

  private

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

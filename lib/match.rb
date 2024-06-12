# frozen_string_literal: true

# Object modeling the data and behavior of a match of Mastermind.
class Match
  attr_reader :code, :colors, :guesses, :turns

  def initialize
    @code = Array.new 4
    @colors = %i[red yellow blue green black white]
    @turns = 12
    @guesses = Array.new(turns) { { guess: [], full_matches: 0, color_only_matches: 0 } }
  end

  def generate_random_code
    code.each_with_index { |_, i| code[i] = colors.sample }
    # @code = %i[red white green black]
    @code = %i[green green blue black]
  end

  def guess(sequence)
    @guesses[-turns][:guess] = sequence.clone

    return true if code == sequence

    remaining_colors = record_full_matches(sequence)
    record_color_only_matches(remaining_colors, sequence)

    @turns -= 1

    pp guesses
    pp remaining_colors
    false
  end

  private

  def record_full_matches(sequence)
    remaining_colors = code.clone
    code.each_with_index do |color, index|
      next unless color == sequence[index]

      @guesses[-turns][:full_matches] += 1
      remaining_colors[index] = nil
      sequence[index] = nil
    end
    remaining_colors
  end

  def record_color_only_matches(unmatched_colors, sequence)
    sequence.compact.each do |color|
      if unmatched_colors.include?(color)
        unmatched_colors.delete_at unmatched_colors.index(color)
        @guesses[-turns][:color_only_matches] += 1
      end
    end
  end
end

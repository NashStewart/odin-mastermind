# frozen_string_literal: true

# Full lines of colors, keeping track of hits
# Stop when four hits or 3 hits and only one color left
# Random combos, keeping track of:
#   - Guesses with no hits
#   - Store index of each color during no hits
#   - Guesses with three hits
#
#   - If two hits, only swap two numbers,
#     then if no hits, got back and swap the other two numbers instead
class Computer
  attr_reader :colors, :total_hits, :possible_codes

  def initialize
    @total_hits = 0
    all_colors = %i[red blue yellow green black white]
    @colors = all_colors.each_with_object({}) { |color, hash| hash[color] = { hits: nil, non_hits: [] } }
  end

  def guess
    one_color_guess if total_hits < 4
  end

  def one_color_guess
    possible_colors = @colors.select { |_color, hash| hash[:hits].nil? }
    color = possible_colors.to_a.sample.first
    # TODO: Medium difficulty - random guess using hit colors if there is only one color left to guess.
    Array.new(4, color)
  end

  def random_guess
    random_guess = possible_codes.sample
    @possible_codes.delete random_guess
  end

  def update_color_match(color, number_of_hits)
    hits = colors[color][:hits]
    return unless hits.nil? || number_of_hits > hits
    return @colors.delete color if number_of_hits.zero?

    @colors[color][:hits] = number_of_hits
    @total_hits += number_of_hits
    @colors.each { |color, hash| @colors.delete color if hash[:hits].nil? } unless total_hits < 4
  end

  def initialize_possible_codes
    @possible_codes = []
    all_colors = colors.each_with_object([]) { |color, array| color.last[:hits].times { array << color.first } }
    all_colors.permutation { |permutation| @possible_codes << permutation }
  end

  def remove_no_hit_indices(guess)
    guess.each_with_index do |color, index|
      @possible_codes.delete_if { |code| code[index] == color }
    end
  end
end

# frozen_string_literal: true

# Object modeling the computer AI as a Mastermind opponent.
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

  # This method is for guesses with all the right colors and 0 position matches.
  def remove_no_hit_indices(guess)
    @possible_codes.delete_if do |perm|
      perm[0] == guess[0] || perm[1] == guess[1] || perm[2] == guess[2] || perm[3] == guess[3]
    end
  end

  # This method is for guesses with one full match and three color only matches.
  def remove_one_hit_indices(guess)
    @possible_codes.delete_if { |perm| number_of_matches(guess, perm) > 1 }
  end

  # This method is for guesses with two full match and two color only matches.
  def remove_two_hit_indices(guess)
    @possible_codes.delete_if { |perm| number_of_matches(guess, perm) != 2 }
  end

  def number_of_matches(guess_one, guess_two)
    matches = 0
    (0..3).each { |i| matches += 1 if guess_one[i] == guess_two[i] }
    matches
  end
end

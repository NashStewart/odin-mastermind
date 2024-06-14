# frozen_string_literal: true

require 'colorize'

# Module for printing CLI display for Mastermind game.
module Printable
  def print(guesses, turns)
    print_top_border
    guesses.each_with_index do |guess, index|
      print_guess guess
      print_divider unless index == turns - 1
    end
    print_bottom_border
  end

  def feedback_pip(color)
    color ? '■'.colorize(color) : background
  end

  private

  def print_top_border
    outside_line = '─' * 31
    inside_line_one = '═' * 7
    inside_line_two = '═' * 19
    outside = "┌#{outside_line}┐"
    inside = "│ ╔#{inside_line_one}╦#{inside_line_two}╗ │"
    puts "#{outside}\n#{inside}"
  end

  def print_bottom_border
    outside_line = '─' * 31
    inside_line_one = '═' * 7
    inside_line_two = '═' * 19
    inside = "│ ╚#{inside_line_one}╩#{inside_line_two}╝ │"
    outside = "└#{outside_line}┘"
    puts "#{inside}\n#{outside}"
  end

  def print_divider
    line_one = '═' * 7
    line_two = '═' * 19
    puts "│ ╠#{line_one}╬#{line_two}╣ │"
  end

  def print_guess(guess)
    feedback_pips = []
    guess[:full_matches].times { feedback_pips << :cyan }
    guess[:color_only_matches].times { feedback_pips << :white }
    colors = guess[:colors]
    puts "#{guess_row(1, feedback_pips, colors)}\n#{guess_row(2, feedback_pips, colors)}"
  end

  def guess_row(row, feedback_pips, colors)
    feedback_row = feedback_panel_row(row, feedback_pips)
    colors_row = colors_panel_row colors
    "#{left_border}#{feedback_row}#{inside_border}#{colors_row}#{right_border}"
  end

  def feedback_panel_row(row, feedback_pips)
    first = row == 1 ? 0 : 2
    second = row == 1 ? 1 : 3
    "#{background}#{feedback_pip feedback_pips[first]}#{background}#{feedback_pip feedback_pips[second]}"
  end

  def colors_panel_row(colors)
    colors = Array.new(4) if colors.all? nil
    colors.reduce('') { |str, color| str + "#{background}#{pixel color}#{background}" }
  end

  def background
    '▓'.colorize :gray
  end

  def pixel(color)
    color ? '██'.colorize(color) : background * 2
  end

  def right_padding
    '▒░'.colorize :gray
  end

  def left_padding
    '░▒'.colorize :gray
  end

  def right_border
    "#{right_padding}║ │"
  end

  def left_border
    "│ ║#{left_padding}"
  end

  def inside_border
    "#{background}║#{background}"
  end
end

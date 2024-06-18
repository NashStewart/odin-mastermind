# frozen_string_literal: true

require 'colorize'

# Module for printing CLI display for Mastermind game.
module Printable
  def print(guesses, turns)
    puts "\n" * 50
    print_top_border
    guesses.each_with_index do |guess, index|
      print_guess guess
      print_divider unless index == turns - 1
    end
    print_bottom_border
  end

  def print_menu(possible_colors)
    menu = possible_colors.reduce('') do |options, color|
      options + "#{feedback_pip(color)}: #{color.to_s.capitalize} "
    end
    puts "Type a color to select\n#{menu}"
  end

  def print_code(code_colors)
    code = code_colors.reduce('') { |str, color| str + " #{feedback_pip(color)} ".colorize(background: :gray) }
    puts "\nThe code is: #{code}"
  end

  private

  def print_top_border
    outside = "┌#{'─' * 31}┐"
    inside = "│ ╔#{'═' * 7}╦#{'═' * 19}╗ │"
    puts "#{outside}\n#{inside}"
  end

  def print_bottom_border
    inside = "│ ╚#{'═' * 7}╩#{'═' * 19}╝ │"
    outside = "└#{'─' * 31}┘"
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

  def pixel(color)
    color ? '██'.colorize(color) : background * 2
  end

  def feedback_pip(color)
    color ? '■'.colorize(color) : background
  end

  def background(color = :gray)
    '▓'.colorize color
  end

  def right_border
    "#{'▒░'.colorize :gray}║ │"
  end

  def left_border
    "│ ║#{'░▒'.colorize :gray}"
  end

  def inside_border
    "#{background}║#{background}"
  end
end

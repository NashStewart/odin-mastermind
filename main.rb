# frozen_string_literal: true

require_relative 'lib/match'

match = Match.new

p match.generate_random_code

match.guess(%i[red white blue green])
# match.print
match.guess(%i[green green red red])
# match.print
match.guess(%i[yellow white green green])
# match.print
match.guess(%i[white black red blue])
# match.print
match.guess(match.code_colors)
match.print

# frozen_string_literal: true

require_relative 'lib/board'
require_relative 'lib/match'

Board.new
match = Match.new

p match.generate_random_code

p match.guess(%i[red white blue green])
p match.guess(%i[green green red red])
p match.guess(match.code)

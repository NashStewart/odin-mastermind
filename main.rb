# frozen_string_literal: true

require_relative 'lib/round'

round = Round.new

p round.generate_random_code

round.guess(%i[red white blue green])
round.guess(%i[green green red red])
round.guess(%i[yellow white green green])
round.guess(%i[white black red blue])
round.guess(round.code_colors)

round.play
round.print

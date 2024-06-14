# frozen_string_literal: true

require_relative 'lib/round'

round = Round.new

winner = round.play ? 'Player' : 'Computer'
puts "#{winner} wins!"

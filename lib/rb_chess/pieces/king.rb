# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to represent a kong in chess
class King < Piece
  attr_reader :move_sets

  def initialize(color, position)
    super
    increments = [{ y: -1, x: -1 }, { y: 1, x: 1 }, { y: 1, x: -1 },
                  { y: -1, x: 1 }, { y: 0, x: -1 }, { y: 0, x: 1 },
                  { y: -1, x: 0 }, { y: 1, x: 0 }]
    @move_sets = [
      MoveSet.new(
        increments: increments,
        repeat: 1,
        blocked_by: [:same],
        special_moves: %i[castle]
      )
    ]
  end
end

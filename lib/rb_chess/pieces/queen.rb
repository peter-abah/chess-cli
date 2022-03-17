# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to represent a queen in a chess game
class Queen < Piece
  attr_reader :move_sets

  def initialize(color, position)
    super
    increments = [{ y: 1, x: 1 }, { y: -1, x: 1 }, { y: -1, x: -1 },
                  { y: 1, x: -1 }, { y: 1, x: 0 }, { y: -1, x: 0 },
                  { y: 0, x: 1 }, { y: 0, x: -1 }]
    @move_sets = [
      MoveSet.new(
        increments: increments,
        repeat: Float::INFINITY,
        blocked_by: [:same]
      )
    ]
  end
end

# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to represent a bishop in a chess game
module RbChess
  class Bishop < Piece
    attr_reader :move_sets

    def initialize(color, position)
      super
      increments = [{ y: 1, x: 1 }, { y: -1, x: 1 }, { y: -1, x: -1 },
                    { y: 1, x: -1 }]
      @move_sets = [
        MoveSet.new(
          increments: increments,
          repeat: Float::INFINITY,
          blocked_by: [:same]
        )
      ]
    end
  end
end

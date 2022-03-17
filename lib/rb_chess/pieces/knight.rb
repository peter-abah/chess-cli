# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to represent a knight in a chess game
module RbChess
  class Knight < Piece
    attr_reader :move_sets

    def initialize(color, position)
      super
      increments = [{ y: 2, x: 1 }, { y: 2, x: -1 }, { y: 1, x: 2 },
                    { y: 1, x: -2 }, { y: -2, x: 1 }, { y: -2, x: -1 },
                    { y: -1, x: 2 }, { y: -1, x: -2 }]
      @move_sets = [
        MoveSet.new(
          increments: increments,
          repeat: 1,
          blocked_by: [:same]
        )
      ]
    end
  end
end

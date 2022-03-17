# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to reperesnt a chess pawn
module RbChess
  class Pawn < Piece
    attr_reader :move_sets, :direction

    def initialize(color, position)
      super

      # where the pawn is facing -1 for up, 1 for down
      @direction = color == :white ? -1 : 1
      repeat = position.starting_pawn_rank?(color) ? 2 : 1
      @move_sets = [
        # for normal move
        MoveSet.new(
          increments: [{ y: direction, x: 0 }],
          repeat: repeat,
          blocked_by: [:piece],
          special_moves: %i[en_passant],
          promotable: true
        ),
        # for capture
        MoveSet.new(
          repeat: 1,
          increments: [{ y: direction, x: 1 }, { y: direction, x: -1 }],
          blocked_by: %i[same empty],
          promotable: true
        )
      ]
    end

    def can_promote?(pos)
      rank = color == :white ? 0 : 7
      pos.y == rank
    end

    def promotion_pieces
      %w[n r q b]
    end
  end
end

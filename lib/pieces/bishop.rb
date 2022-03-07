# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to represent a bishop in a chess game
class Bishop < Piece
  attr_reader :move_sets

  def initialize(color)
    super
    increments = [{ y: 1, x: 1 }, { y: -1, x: 1 }, { y: -1, x: -1 },
                  { y: 1, x: -1 }]
    @move_sets = [MoveSet.new(increments: increments, repeat: Float::INFINITY,
                              blocked_by: :player_piece)]
  end

  # def possible_moves(board, pos)
  #   y, x = pos
  #   board_array = board.board_array
  #   piece = board_array[y][x]
  #   return [] unless piece&.color == color && piece.is_a?(Bishop)

  #   gen_moves(board_array, pos)
  # end
end

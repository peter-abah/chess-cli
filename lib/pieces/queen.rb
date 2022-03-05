# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to represent a queen in a chess game
class Queen < Piece
  include MoveGenerator

  attr_reader :directions

  def initialize(color)
    super
    directions = [{ y: 1, x: 1 }, { y: -1, x: 1 }, { y: -1, x: -1 },
                  { y: 1, x: -1 }, { y: 1, x: 0 }, { y: -1, x: 0 },
                  { y: 0, x: 1 }, { y: 0, x: -1 }]
    @move_sets = [MoveSet.new(directions: directions, repeat: Float::INFINITY,
                              blocked_by: :player_piece)]
  end

  # def possible_moves(board, pos)
  #   y, x = pos
  #   board_array = board.board_array
  #   piece = board_array[y][x]
  #   return [] unless piece&.color == color && piece.is_a?(Queen)

  #   gen_moves(board_array, pos)
  # end
end

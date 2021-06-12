# frozen_string_literal: true

require_relative '../move'
require_relative '../move_generator'

# A class to represent a rook in a chess game
class Rook
  include MoveGenerator

  attr_reader :color, :directions, :has_moved

  def initialize(color)
    @color = color
    @directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    @has_moved = false
  end

  def possible_moves(board, pos)
    y, x = pos
    board_array = board.board_array
    piece = board_array[y][x]
    return [] unless piece&.color == color && piece.is_a?(Rook)

    gen_moves(board_array, pos)
  end
end

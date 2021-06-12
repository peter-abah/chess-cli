# frozen_string_literal: true

require_relative '../move'
require_relative '../move_generator'

# A class to represent a bishop in a chess game
class Bishop
  include MoveGenerator

  attr_reader :color, :directions

  def initialize(color)
    @color = color
    @directions = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end

  def possible_moves(board, pos)
    y, x = pos
    board_array = board.board_array
    piece = board_array[y][x]
    return [] unless piece&.color == color && piece.is_a?(Bishop)

    gen_moves(board_array, pos)
  end
end

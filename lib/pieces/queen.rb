# frozen_string_literal: true

require_relative '../move'
require_relative '../move_generator'
require_relative 'piece'

# A class to represent a queen in a chess game
class Queen < Piece
  include MoveGenerator

  attr_reader :directions

  def initialize(color)
    super
    @directions = [[1, 1], [-1, 1], [-1, -1], [1, -1], [0, 1], [0, -1],
                   [1, 0], [-1, 0]]
  end

  def possible_moves(board, pos)
    x, y = pos
    board_array = board.board_array
    piece = board_array[y][x]
    return [] unless piece&.color == color && piece.is_a?(Queen)

    gen_moves(board_array, pos)
  end
end

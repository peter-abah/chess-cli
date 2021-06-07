# frozen_string_literal: true

require_relative '../move'

# A class to represent a bishop in a chess game
class Bishop
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def possible_moves(board, pos)
    y, x = pos
    board_array = board.board_array
    piece = board_array[y][x]
    return [] unless piece&.color == color && piece.is_a?(Bishop)

    valid_moves(board_array, pos)
  end

  def valid_moves(board_array, pos)
    result = []

    moves = bishop_moves(board_array, pos, [1, 1])
    result.concat(moves)

    moves = bishop_moves(board_array, pos, [-1, 1])
    result.concat(moves)

    moves = bishop_moves(board_array, pos, [-1, -1])
    result.concat(moves)

    moves = bishop_moves(board_array, pos, [1, -1])
    result.concat(moves)
  end

  def bishop_moves(board_array, pos, step)
    result = []
    y_step, x_step = step
    new_pos = [pos[0] + y_step, pos[1] + x_step]

    while valid_move?(board_array, new_pos)
      move = rook_move(board_array, pos, new_pos)
      result.push(move)
      break if move.removed

      new_pos = [new_pos[0] + y_step, new_pos[1] + x_step]
    end

    result
  end
end

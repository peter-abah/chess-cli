# frozen_string_literal: true

require_relative '../move'

# A class to represent a rook in a chess game
class Rook
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def possible_moves(board, pos)
    y, x = pos
    board_array = board.board_array
    piece = board_array[y][x]
    return [] unless piece&.color == color && piece.is_a?(Rook)

    valid_moves(board_array, pos)
  end

  def valid_moves(board_array, pos)
    result = []

    moves = rook_moves(board_array, pos, [0, 1])
    result.concat(moves)

    moves = rook_moves(board_array, pos, [0, -1])
    result.concat(moves)

    moves = rook_moves(board_array, pos, [1, 0])
    result.concat(moves)

    moves = rook_moves(board_array, pos, [-1, 0])
    result.concat(moves)
  end

  def rook_moves(board_array, pos, step)
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

  def valid_move?(board_array, pos)
    y, x = pos
    return false unless y.between?(0, 7) && x.between?(0, 7)

    board_array[y][x].nil? || board_array[y][x].color != color
  end

  def rook_move(board_array, pos, new_pos)
    move = Move.new(pos, new_pos)

    yn, xn = new_pos
    piece = board_array[yn][xn]
    move.removed = new_pos unless piece.nil? || piece.color == color

    move
  end
end

# frozen_string_literal: true

require_relative '../move'

# A class to reperesnt a chess pawn
class Pawn
  attr_reader :color, :direction

  def initialize(color)
    @color = color
    @start_pos = color == 'white' ? 6 : 1 # the index in the board which is the pawn's position in the board
    @direction = color == 'white' ? -1 : 1 # where the pawn is facing -1 for up, 1 for down
  end

  def possible_moves(board, pos)
    board_array = board.board_array
    result = []
    y, x = pos
    piece = board_array[y][x]

    return result unless piece.is_a? Pawn

    moves = normal_moves(board_array, pos)
    result.concat(moves)

    moves = capture_moves(board_array, pos)
    result.concat(moves)
  end

  private

  def normal_moves(board_array, pos)
    y, x = pos
    result = []

    yn = y + direction
    return result unless board_array[yn][x].nil?

    move = Move.new(pos, [yn, x])
    result.push(move)

    return result unless y == @start_pos

    yn = y + (direction * 2)
    move = Move.new(pos, [yn, x])
    result.push(move)

    result
  end

  def capture_moves(board_array, pos)
    y, x = pos
    yn = y + direction
    result = []

    xn = x - 1
    piece = xn >= 0 ? nil : board_array[yn][xn]
    result.push(capture_move(piece, pos, [yn, xn])) unless piece.nil?

    xn = x + 1
    piece = xn < 8 ? board_array[yn][xn] : nil
    result.push(capture_move(piece, pos, [yn, xn])) unless piece.nil?

    result
  end

  def capture_move(piece, pos, new_pos)
    return if piece.color == color

    Move.new(pos, new_pos, new_pos)
  end
end

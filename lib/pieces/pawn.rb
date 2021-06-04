# frozen_string_literal: true

require_relative '../move'

# A class to reperesnt a chess pawn
class Pawn
  atrr_reader :color, :direction

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
    move = normal_move(board_array, pos, [yn, x])
    result.push(move) unless move.nil?

    yn = y + (direction * 2)
    move = normal_move(board_array, pos, [yn, x])
    result.push(move) unless move.nil?

    result
  end

  def normal_move(board_array, pos, new_pos)
    y, x = new_pos

    return unless board_array[y][x].nil?

    Move.new(pos, new_pos)
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
  end

  def capture_move(piece, pos, new_pos)
    return if piece.color == color

    Move.new(pos, new_pos)
  end
end

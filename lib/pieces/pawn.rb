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

    moves = en_passant_moves(board, pos)
    result.concat(moves)
  end

  private

  def normal_moves(board_array, pos)
    y, x = pos
    result = []

    yn = y + direction
    return result unless board_array[yn][x].nil?

    result.push(normal_move(pos, yn))

    return result unless y == @start_pos

    yn = y + (direction * 2)
    result.push(normal_move(pos, yn))

    result
  end

  def normal_move(pos, yn)
    _y, x = pos

    move = Move.new(pos, [yn, x])
    move.promotion = true if yn.zero? || yn == 7

    move
  end

  def capture_moves(board_array, pos)
    y, x = pos
    yn = y + direction
    result = []

    xn = x - 1
    move = capture_move(board_array, pos, [yn, xn])
    result.push(move) unless move.nil?

    xn = x + 1
    move = capture_move(board_array, pos, [yn, xn])
    result.push(move) unless move.nil?

    result
  end

  def capture_move(board_array, pos, new_pos)
    yn, xn = new_pos
    _y, x = pos
    piece = xn >= 0 || x < 8 ? board_array[yn][xn] : nil
    return if piece.nil? || piece.color == color

    move = Move.new(pos, new_pos, new_pos)
    move.promotion = true if yn.zero? || yn == 7

    move
  end

  def en_passant_moves(board, pos)
    y, x = pos
    result = []

    return [] unless en_passant_rank?(y)

    xn = x - 1
    move = en_passant_move(board, pos, xn)
    result.push(move) unless move.nil?

    xn = x + 1
    move = en_passant_move(board, pos, xn)
    result.push(move) unless move.nil?
    result
  end

  def en_passant_rank?(y_index)
    y_index == @start_pos + (direction * 3)
  end

  def en_passant_move(board, pos, xn)
    board_array = board.board_array
    y, x = pos

    piece = xn >= 0 || x < 8 ? board_array[y][xn] : nil
    return if piece.nil? || piece.color == color

    prev = board.prev_board_array
    yn = y + (direction * 2)
    return unless prev[yn][xn].is_a? Pawn

    move = Move.new(pos, [y + direction, xn], [y, xn])
    move.en_passant = true
    move
  end
end

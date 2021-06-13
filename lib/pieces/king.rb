# frozen_string_literal: true

require_relative '../move'
require_relative 'rook'

# A class to represent a kong in chess
class King
  attr_reader :color, :has_moved, :directions

  def initialize(color)
    @color = color
    @has_moved = false
    @directions = [[-1, -1], [1, 1], [1, -1], [-1, 1], [0, -1], [0, 1], [-1, 0], [1, 0]]
  end

  def possible_moves(board, pos)
    y, x = pos
    board_array = board.board_array
    piece = board_array[y][x]
    return [] unless piece&.color == color && piece.is_a?(King)

    gen_moves(board_array, pos)
  end

  def gen_moves(board_array, pos)
    normal_moves(board_array, pos) + castle_moves(board_array, pos)
  end

  def normal_moves(board_array, pos)
    result = []
    directions.each do |dir|
      move = normal_move(board_array, pos, dir)
      result.push(move)
    end

    result.reject(&:nil?)
  end

  def normal_move(board_array, pos, dir)
    y, x = pos
    yn, xn = y + dir[0], x + dir[1]
    return unless valid_move?(board_array, [yn, xn])

    move = Move.new(pos, [yn, xn])
    move.removed = [yn, xn] unless board_array[yn][xn].nil?

    move
  end

  def valid_move?(board_array, pos)
    y, x = pos
    return false unless y.between?(0, 7) && x.between?(0, 7)

    piece = board_array[y][x]
    piece.nil? || piece&.color != color
  end

  def castle_moves(board_array, pos)
    return [] if has_moved

    result = []
    move = kingside(board_array, pos)
    result.push(move) if move

    move = queenside(board_array, pos)
    result.push(move) if move

    result
  end

  def kingside(board_array, pos)
    y, x = pos
    return unless board_array[y][5].nil? && board_array[y][6].nil?

    rook = board_array[y][7]
    return unless rook.is_a?(Rook) && rook.color == color && !rook.has_moved

    move = Move.new(pos, [y, x + 2])
    move.moved[[y, 7]] = [y, x + 1]
    move.castle = true

    move
  end

  def queenside(board_array, pos)
    y, x = pos
    return unless board_array[y][3].nil? && board_array[y][2].nil? &&
                  board_array[y][1].nil?

    rook = board_array[y][0]
    return unless rook.is_a?(Rook) && rook.color == color && !rook.has_moved

    move = Move.new(pos, [y, x - 2])
    move.moved[[y, 0]] = [y, x - 1]
    move.castle = true

    move
  end
end

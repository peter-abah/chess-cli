# frozen_string_literal: true

require_relative '../move'
require_relative 'rook'
require_relative 'piece'

# A class to represent a kong in chess
class King < Piece
  attr_reader :directions, :default_position

  def initialize(color)
    super
    @default_position = color == 'white' ? [7, 4] : [0, 4]
    @directions = [[-1, -1], [1, 1], [1, -1], [-1, 1], [0, -1], [0, 1], [-1, 0], [1, 0]]
  end

  def possible_moves(board, pos)
    y, x = pos
    piece = board.piece_at(y: y, x: x)
    raise ArgumentError unless piece == self

    gen_moves(board, pos)
  end

  def gen_moves(board, pos)
    normal_moves(board, pos) + castle_moves(board, pos)
  end

  def normal_moves(board, pos)
    result = []
    directions.each do |dir|
      move = normal_move(board, pos, dir)
      result.push(move)
    end

    result.reject(&:nil?)
  end

  def normal_move(board, pos, dir)
    y, x = pos
    yn, xn = y + dir[0], x + dir[1]
    return unless valid_move?(board, [yn, xn])

    move = Move.new(pos, [yn, xn])
    move.removed = [yn, xn] unless board.piece_at(y: yn, x: xn).nil?
    move
  end

  def valid_move?(board, pos)
    y, x = pos
    return false unless y.between?(0, 7) && x.between?(0, 7)

    piece = board.piece_at(y: y, x: x)
    piece.nil? || piece&.color != color
  end

  def castle_moves(board, pos)
    return [] unless default_position == pos

    moves = [
      kingside_castle_move(board, pos),
      queenside_castle_move(board, pos)
    ]
    moves.reject(&:nil?)
  end

  def kingside_castle_move(board, pos)
    y, x = pos
    return unless kingside_castle_possible?(board, y)

    move = Move.new(pos, [y, x + 2])
    move.add_move(from: [y, 7], destination: [y, x + 1])
    move.castle = true
    move
  end

  def kingside_castle_possible?(board, y)
    return false unless board.piece_at(y: y, x: 5).nil? && board.piece_at(y: y, x: 6).nil?

    rook = board.piece_at(y: y, x: 7)
    rook.is_a?(Rook) && rook.color == color
  end

  def queenside_castle_move(board, pos)
    y, x = pos
    return unless queenside_castle_possible?(board, y)

    move = Move.new(pos, [y, x - 2])
    move.add_move(from: [y, 0], destination: [y, x - 1])
    move.castle = true
    move
  end

  def queenside_castle_possible?(board, y)
    return false unless board.piece_at(y: y, x: 3).nil? &&
                        board.piece_at(y: y, x: 2).nil? && board.piece_at(y: y, x: 1).nil?

    rook = board.piece_at(y: y, x: 0)
    rook.is_a?(Rook) && rook.color == color
  end
end

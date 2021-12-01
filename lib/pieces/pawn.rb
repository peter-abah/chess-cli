# frozen_string_literal: true

require 'pry-byebug'
require_relative '../move'
require_relative 'piece'

# A class to reperesnt a chess pawn
class Pawn < Piece
  attr_reader :direction, :start_pos

  def initialize(color)
    super
    @start_pos = color == 'white' ? 6 : 1 # the index in the board which is the pawn's position in the board
    @direction = color == 'white' ? -1 : 1 # where the pawn is facing -1 for up, 1 for down
  end

  def possible_moves(board, pos)
    y, x = pos
    piece = board.piece_at(y: y, x: x)
    raise error unless piece == self

    moves = [
      normal_moves(board, pos),
      capture_moves(board, pos),
      en_passant_moves(board, pos)
    ]
    moves.reduce { |total, m| total + m }
  end

  private

  def normal_moves(board, pos)
    y, = pos
    result = [normal_move(board, pos, direction)]
    result.push(normal_move(board, pos, direction * 2)) if y == start_pos
    result.reject(&:nil?)
  end

  def normal_move(board, pos, y_amount)
    y, x = pos
    yn = y + y_amount
    return unless normal_move_possible?(board, [yn, x])

    move = Move.new(pos, [yn, x])
    move.promotion = true if yn.zero? || yn == 7
    move
  end

  def normal_move_possible?(board, (y, x))
    y > 7 || board.piece_at(y: y, x: x).nil?
  end

  def capture_moves(board, pos)
    y, x = pos
    yn = y + direction
    x_left = x - 1
    x_right = x + 1

    moves = [
      capture_move(board, pos, [yn, x_left]),
      capture_move(board, pos, [yn, x_right])
    ]
    moves.reject(&:nil?)
  end

  def capture_move(board, pos, new_pos)
    yn, = new_pos
    return unless capture_move_possible?(board, new_pos)

    move = Move.new(pos, new_pos, new_pos)
    move.promotion = true if yn.zero? || yn == 7
    move
  end

  def capture_move_possible?(board, (y, x))
    return false unless x.between?(0, 7)

    piece = board.piece_at(y: y, x: x)
    !(piece.nil? || piece.color == color)
  end

  def en_passant_moves(board, pos)
    y, x = pos
    x_left = x - 1
    x_right = x + 1
    return [] unless en_passant_rank?(y)

    moves = [
      en_passant_move(board, pos, x_left),
      en_passant_move(board, pos, x_right)
    ]
    moves.reject(&:nil?)
  end

  def en_passant_rank?(y_pos)
    y_pos == start_pos + (direction * 3)
  end

  def en_passant_move(board, pos, xn)
    y, = pos
    piece = xn.between?(0, 7) ? board.piece_at(y: y, x: xn) : nil
    return unless piece.is_a?(Pawn) && piece.color != color

    prev_state = board.prev_state
    yn = y + (direction * 2)
    return unless prev_state.piece_at(y: yn, x: xn).is_a? Pawn

    move = Move.new(pos, [y + direction, xn], [y, xn])
    move.en_passant = true
    move
  end
end

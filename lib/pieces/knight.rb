# frozen_string_literal: true

require_relative '../move_set'
require_relative 'piece'

# A class to represent a knight in a chess game
class Knight < Piece
  attr_reader :move_sets

  def initialize(color)
    super
    directions = [{ y: 2, x: 1 }, { y: 2, x: -1 }, { y: 1, x: 2 },
                  { y: 1, x: -2 }, { y: -2, x: 1 }, { y: -2, x: -1 },
                  { y: -1, x: 2 }, { y: -1, x: -2 }]
    @move_sets = [MoveSet.new(directions: directions, repeat: 1,
                              blocked_by: :player_piece)]
  end

  # def possible_moves(board, pos)
  #   y, x = pos
  #   board_array = board.board_array
  #   piece = board_array[y][x]
  #   return [] unless piece.is_a?(Knight) && piece.color == color

  #   valid_moves(board_array, pos)
  # end

  # def valid_moves(board_array, pos)
  #   y, x = pos
  #   result = []

  #   [-1, -2, 1, 2].each do |n|
  #     if n.abs == 1
  #       result.push(normal_move(board_array, pos, [y - 2, x + n]))
  #       result.push(normal_move(board_array, pos, [y + 2, x + n]))
  #     else
  #       result.push(normal_move(board_array, pos, [y - 1, x + n]))
  #       result.push(normal_move(board_array, pos, [y + 1, x + n]))
  #     end
  #   end

  #   result.reject(&:nil?)
  # end

  # def normal_move(board_array, pos, new_pos)
  #   return unless valid_move?(board_array, new_pos)

  #   yn, xn = new_pos
  #   move = Move.new(pos, new_pos)
  #   move.removed = new_pos unless board_array[yn][xn].nil?

  #   move
  # end

  # def valid_move?(board_array, (yn, xn))
  #   return false unless yn.between?(0, 7) && xn.between?(0, 7)
 
  #   board_array[yn][xn]&.color != color
  # end
end

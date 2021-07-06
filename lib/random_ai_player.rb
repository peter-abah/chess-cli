# frozen_string_literal: true

require_relative 'game_func'

# A class to represent an ai that plays random legal chess moves
class RandomAIPlayer
  include GameFunc

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_move(board)
    moves = legal_moves(board)
    moves.sample
  end

  def legal_moves(board)
    result = []

    pieces = board.player_pieces(color)
    pieces.each do |piece, pos|
      move = piece.possible_moves(board, pos)
      result.concat(move)
    end

    result.select { |move| legal_move?(move, self, board) }
  end
end

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
    moves = legal_moves(board, self)
    move = moves.sample

    puts "computer played #{move}"
    move
  end
end

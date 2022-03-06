# frozen_string_literal: true

require_relative '../game_func'

# A class to represent an ai that plays random legal chess moves
class ComputerPlayer
  include GameFunc

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_move(board)
    moves = valid_moves(board, self)
    move = moves.sample

    move.promotion = PROMOTION_CHOICES.values.sample if move.promotion
    puts "computer played #{move}"
    move
  end
end

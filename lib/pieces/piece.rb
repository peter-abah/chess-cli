# frozen_string_literal: true

# A super class for the chess pieces
class Piece
  attr_reader :color
  attr_accessor :has_moved

  def initialize(color)
    @color = color
    @has_moved = false
  end
end

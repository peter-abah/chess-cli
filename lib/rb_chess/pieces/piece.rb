# frozen_string_literal: true

# A super class for the chess pieces
module RbChess
  class Piece
    attr_reader :color, :position
    attr_accessor :has_moved

    def initialize(color, position)
      @color = color
      @has_moved = false
      @position = position
    end

    def update_position(new_pos)
      self.class.new(color, new_pos)
    end
  end
end

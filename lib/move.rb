# frozen_string_literal: true

# A class to represent a chess move
class Move
  attr_accessor :moved, :removed

  def initialize(position, destination)
    @removed = nil
    @moved = {}
    @moved[position] = destination
  end
end

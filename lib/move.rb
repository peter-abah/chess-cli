# frozen_string_literal: true

# A class to represent a chess move
class Move
  attr_reader :removed
  attr_accessor :moved

  def initialize(position, destination)
    @removed = []
    @moved = {}
    @moved[position] = destination
  end
end

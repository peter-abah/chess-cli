# frozen_string_literal: true

# A class to represent a chess move
class Move
  attr_accessor :moved, :removed, :en_passant, :promotion

  def initialize(position, destination, removed = nil)
    @en_passant = false
    @promotion = false
    @removed = removed
    @moved = {}
    @moved[position] = destination
  end
end

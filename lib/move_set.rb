# frozen_string_literal: true|

# A class to represent info about how a piece moves on the body
class MoveSet
  attr_accessor :directions, :repeat, :blocked_by, :special_moves

  def initialize(directions:, repeat:, blocked_by:, special_moves: [])
    @directions = directions
    @repeat = repeat
    @blocked_by = blocked_by
    @special_moves = special_moves
  end
end

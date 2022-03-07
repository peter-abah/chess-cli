# frozen_string_literal: true|

# A class to represent info about how a piece moves on the body
class MoveSet
  attr_accessor :increments, :repeat, :blocked_by, :special_moves

  def initialize(increments:, repeat:, blocked_by:, special_moves: [])
    @increments = increments
    @repeat = repeat
    @blocked_by = blocked_by
    @special_moves = special_moves
  end
end

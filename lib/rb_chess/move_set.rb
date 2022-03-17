# frozen_string_literal: true|

# A class to represent info about how a piece moves on the body
module RbChess
class MoveSet
  attr_accessor :increments, :repeat, :blocked_by, :promotable, :special_moves

  def initialize(increments:, repeat:, blocked_by: [], special_moves: [], promotable: false)
    @increments = increments
    @repeat = repeat
    @blocked_by = blocked_by
    @special_moves = special_moves
    @promotable = promotable
  end
end
end

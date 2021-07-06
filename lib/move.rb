# frozen_string_literal: true

# A class to represent a chess move
class Move
  attr_accessor :moved, :removed, :en_passant, :promotion, :castle

  def initialize(position, destination, removed = nil)
    @en_passant = false
    @promotion = false
    @castle = false

    @removed = removed
    @moved = {}
    @moved[position] = destination
  end

  def to_s
    result = []
    @moved.each do |pos, dest|
      y, x = pos
      pos = "#{(97 + y).chr}#{8 - x}"

      y, x = dest
      dest = "#{(97 + y).chr}#{8 - x}"
      result.push("|#{pos} => #{dest}|")
    end

    result.join(', ')
  end
end

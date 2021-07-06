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
      pos = "#{(97 + x).chr}#{8 - y}"

      y, x = dest
      dest = "#{(97 + x).chr}#{8 - y}"
      result.push("|#{pos} => #{dest}|")
    end

    result.join(', ')
  end
end

# frozen_string_literal: true

# A class to represent a chess move
class Move
  attr_accessor :moved, :removed, :en_passant, :promotion, :castle

  def initialize(position, destination, removed = nil)
    @en_passant = false
    @promotion = false
    @castle = false

    @removed = removed
    @moved = { position => destination }
  end

  def add_move(position:, destination:)
    moved[position] = destination
  end

  def destination_for(position:)
    moved[position]
  end

  def to_s
    result = []
    @moved.each do |pos, dest|
      move_str = move_to_str(position: pos, destination: dest)
      result.push(move_str)
    end

    result.join(', ')
  end

  private

  def move_to_str(position:, destination:)
    position_str = position_to_str(position: position)
    destination_str = position_to_str(position: destination)
    "|#{position_str} => #{destination_str}|"
  end

  def position_to_str(position:)
    y, x = position
    "#{(97 + x).chr}#{8 - y}"
  end
end

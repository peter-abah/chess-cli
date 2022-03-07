# frozen_string_literal: true

# a class to represent a position in a chess game
class Position
  attr_reader :y, :x
  
  def self.parse(string)
    raise ArgumentError.new 'invalid position' unless /^[a-h][1-8]$/.match string
    
    x = string[0].ord - 97
    y = 8 - string[1].to_i
    Position.new(y: y, x: x)
  end

  def initialize(y:, x:)
    @y = y
    @x = x
  end
  
  def to_s
    "#{(97 + x).chr}#{8-y}"
  end
  
  def ==(another_position)
    return false unless another_position.is_a? Position
    
    x == another_position.x && y == another_position.y
  end
  
  def increment(y: 0, x: 0)
    Position.new(y: self.y + y, x: self.x + x)
  end
end
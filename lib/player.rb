# frozen_string_literal: true

# a class to represent a player in a chess game
class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end
end
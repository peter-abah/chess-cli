# frozen_string_literal: true

# a class to represent a human player in a chess game
class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end
end
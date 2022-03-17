# frozen_string_literal: true

module RbChess
  class Player
    attr_reader :color, :name

    def initialize(color)
      @color = color
      @name = color.to_s.capitalize
    end
  end

  class ComputerPlayer < Player; end

  class RandomAI < ComputerPlayer
    def move(game)
      game.all_moves.sample
    end
  end
end

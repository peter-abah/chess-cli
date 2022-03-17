# frozen_string_literal: true

# A class to represent a chess move
module RbChess
  class Move
    attr_reader :moved, :removed, :promotion, :castle

    def initialize(from:, to:, removed: nil, promotion: nil, castle: nil)
      @promotion = promotion
      @castle = castle
      @removed = Position.parse(removed) if removed
      @moved = [{ from: Position.parse(from), to: Position.parse(to) }].freeze
    end

    def add_move(from:, to:)
      @moved = [*moved, { from: Position.parse(from), to: Position.parse(to) }].freeze
    end

    def destination_for(from)
      hash = moved.find { |hash| hash[:from] == from }
      hash[:to]
    end

    def to_s
      return '0-0' if castle == :kingside

      return '0-0-0' if castle == :queenside

      moves = moved.map { |hash| "#{hash[:from]}#{hash[:to]}#{promotion.to_s.upcase}" }
      moves.join(',')
    end
  end
end

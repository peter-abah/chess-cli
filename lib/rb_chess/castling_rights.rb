# frozen_string_literal: true

module RbChess
  class CastlingRights
    attr_reader :kingside, :queenside

    def initialize(kingside: nil, queenside: nil)
      @kingside = kingside || { white: false, black: false }
      @queenside = queenside || { white: false, black: false }
    end

    def to_s
      res = ''

      res += 'K' if kingside[:white]
      res += 'Q' if queenside[:white]
      res += 'k' if kingside[:black]
      res += 'q' if queenside[:black]

      res = '-' if res.empty?

      res
    end

    def dup
      new_kingside = kingside.dup
      new_queenside = queenside.dup
      CastlingRights.new(kingside: new_kingside, queenside: new_queenside)
    end
  end
end

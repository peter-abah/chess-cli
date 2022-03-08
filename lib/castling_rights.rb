# frozen_string_literal: true

class CastlingRights
  attr_reader :kingside, :queenside

  def initialize
    @kingside ||= { white: false, black: false }
    @queenside ||= { white: false, black: false}
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
end
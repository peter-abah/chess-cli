# frozen_string_literal: true

# A class to parse Chess FEN notation
# It only parses the chess board part and will raise an error
# if  that is not the only part passed
# Valid FEN: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
# Invalid FEN: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w' or any other
class FENParser
  DEFAULT_NOTATION = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'

  attr_reader :fen_notation

  def initialize(fen_notation = DEFAULT_NOTATION)
    @fen_notation = fen_notation
  end
end

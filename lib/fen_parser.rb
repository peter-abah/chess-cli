# frozen_string_literal: true

require_rel 'pieces'
# A class to parse Chess FEN notation
# It only parses the chess board part and will raise an error
# if  that is not the only part passed
# Valid FEN: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
# Invalid FEN: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w' or any other
class FENParser
  BOARD_HEIGHT = 8
  BOARD_WIDTH = 8

  DEFAULT_NOTATION = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
  FEN_TOKEN_REGEX = /[pkqrbn\d]/i.freeze
  PIECE_CLASSES = {
    p: Pawn,
    k: King,
    q: Queen,
    r: Rook,
    b: Bishop,
    n: Knight
  }.freeze

  ERROR_MESSAGES = {
    invalid_token: 'Invalid FEN notation, token not valid',
    invalid_board_width: "Invalid FEN notation, Board width is not longer than #{BOARD_WIDTH}",
    invalid_board_height: "Invalid FEN notation, Board height not equal to #{BOARD_HEIGHT}"
  }.freeze

  attr_reader :fen_notation

  def initialize(fen_notation = DEFAULT_NOTATION)
    @fen_notation = fen_notation
  end

  def parse
    board = fen_notation.split('/')
    raise ArgumentError, ERROR_MESSAGES[:invalid_board_height] if board.length != BOARD_HEIGHT

    board.map { |rank_fen| parse_rank_fen(rank_fen) }
  end

  def parse_rank_fen(rank_fen)
    rank = rank_fen.split('')
    rank = rank.reduce([]) { |result, token| result + parse_fen_token(token) }
    raise ArgumentError, ERROR_MESSAGES[invalid_board_width] if rank.length != BOARD_WIDTH

    rank
  end

  def parse_fen_token(token)
    raise ArgumentError, ERROR_MESSAGES[invalid_token] unless FEN_TOKEN_REGEX.match(token)

    return Array.new(token.to_i) if is_integer?(token)

    color = token == token.upcase ? 'white' : 'black'
    piece = PIECE_CLASSES[token.downcase.to_sym].new(color)
    [piece]
  end

  def is_integer?(string)
    string.to_i.to_s == string
  end
end

# frozen_string_literal: true

require 'pry-byebug'
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
  LETTER_TO_PIECE_CLASS = {
    p: Pawn,
    k: King,
    q: Queen,
    r: Rook,
    b: Bishop,
    n: Knight
  }.freeze

  PIECE_CLASS_TO_LETTER = {
    Pawn: 'p',
    Rook: 'r',
    Knight: 'n',
    Bishop: 'b',
    Queen: 'q',
    King: 'k'
  }.freeze

  ERROR_MESSAGES = {
    invalid_token: 'Invalid FEN notation, token not valid',
    invalid_board_width: "Invalid FEN notation, Board width is not longer than #{BOARD_WIDTH}",
    invalid_board_height: "Invalid FEN notation, Board height not equal to #{BOARD_HEIGHT}"
  }.freeze

  attr_reader :fen_notation

  def self.board_to_fen(board:)
    board = board.map { |rank| rank_to_fen(rank) }
    board.join('/')
  end

  def self.rank_to_fen(rank)
    no_of_consecutive_empty_cells = 0

    rank.each_with_index.reduce('') do |rank_fen, (piece, index)|
      if piece.nil?
        no_of_consecutive_empty_cells += 1
        index == (BOARD_WIDTH - 1) ? rank_fen + no_of_consecutive_empty_cells.to_s : rank_fen
      else
        if no_of_consecutive_empty_cells != 0
          rank_fen = rank_fen + no_of_consecutive_empty_cells.to_s 
          no_of_consecutive_empty_cells = 0
        end
        
        letter = PIECE_CLASS_TO_LETTER[piece.class.name.to_sym]
        letter = piece.color == 'white' ? letter.upcase : letter
        rank_fen + letter
      end
    end
  end

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
    piece = LETTER_TO_PIECE_CLASS[token.downcase.to_sym].new(color)
    [piece]
  end

  def is_integer?(string)
    string.to_i.to_s == string
  end
end

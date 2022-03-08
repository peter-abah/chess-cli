# frozen_string_literal: true

require 'pry-byebug'
require 'require_all'
require_rel 'pieces'
require_relative './position'

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
    invalid_board_width: "Invalid FEN notation, Board width is not equal to #{BOARD_WIDTH}",
    invalid_board_height: "Invalid FEN notation, Board height not equal to #{BOARD_HEIGHT}"
  }.freeze

  attr_reader :fen_notation

  def self.board_to_fen(board:)
    board = board.map { |rank| rank_to_fen(rank) }
    board.join('/')
  end
  
  def self.pieces_to_fen(pieces)
    (0..7).map { |y| build_rank_fen(pieces, y) }.join('/')
  end
  
  def self.build_rank_fen(pieces, y)
    rank = ''
    no_of_consecutive_empty_cells = 0

    0.upto(7) do |x|
      piece = pieces.find { |piece| piece.position.y == y && piece.position.x == x }

      if piece.nil?
        no_of_consecutive_empty_cells += 1
        rank += no_of_consecutive_empty_cells.to_s if x == (BOARD_WIDTH - 1)
      else
        rank += get_piece_letter(piece, no_of_consecutive_empty_cells)
        no_of_consecutive_empty_cells = 0
      end
    end
    
    rank
  end

  def self.get_piece_letter(piece, no_of_consecutive_empty_cells)
    result = ''
    result += no_of_consecutive_empty_cells.to_s if no_of_consecutive_empty_cells != 0

    letter = PIECE_CLASS_TO_LETTER[piece.class.name.to_sym]
    letter = piece.color == 'white' ? letter.upcase : letter
    result + letter
  end

  def initialize(fen_notation = DEFAULT_NOTATION)
    @fen_notation = fen_notation
  end
  
  def parse
    ranks = fen_notation.split('/')
    raise ArgumentError, ERROR_MESSAGES[:invalid_board_height] if ranks.length != BOARD_HEIGHT
    
    ranks.each_with_index.reduce([]) { |res, (rank, y)| res.concat parse_rank_fen(rank, y) }
  end
  
  def parse_rank_fen(rank_fen, y)
    tokens = rank_fen.split('')
    pos = Position.new(y: y, x: -1)

    pieces = tokens.reduce([]) do |res, token|
      piece, pos = parse_token(token, pos)
      res.push(piece)
    end
    
    raise ArgumentError, ERROR_MESSAGES[:invalid_board_width] if pos.x + 1 != BOARD_WIDTH
    pieces.reject(&:nil?)
  end
  
  def parse_token(token, pos)
    raise ArgumentError, ERROR_MESSAGES[:invalid_token] unless FEN_TOKEN_REGEX.match(token)

    if is_integer? token
      pos = pos.increment(x: token.to_i)
      piece = nil
    else
      color = token.upcase == token ? 'white' : 'black'
      piece_class = LETTER_TO_PIECE_CLASS[token.downcase.to_sym]
      
      pos = pos.increment(x: 1)
      piece = piece_class.new(color, pos)
    end
    
    [piece, pos]
  end

  def is_integer?(string)
    /^\d+$/.match string
  end
end

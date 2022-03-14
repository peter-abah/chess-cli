# frozen_string_literal: true

require_relative './pieces/piece_constants'
require_relative './position'
require_relative './castling_rights'
require_relative './errors'

# A class to parse Chess FEN notation
class FENParser
  include PieceConstants

  BOARD_HEIGHT = 8
  BOARD_WIDTH = 8

  DEFAULT_NOTATION = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0'
  FEN_TOKEN_REGEX = /[pkqrbn\d]/i.freeze

  ERROR_MESSAGES = {
    invalid_token: 'Invalid FEN notation, token not valid',
    invalid_board_width: "Invalid FEN notation, Board width is not equal to #{BOARD_WIDTH}",
    invalid_board_height: "Invalid FEN notation, Board height not equal to #{BOARD_HEIGHT}"
  }.freeze

  def self.board_to_fen(board)
    pieces = pieces_to_fen(board.pieces)
    active = board.active_color == :white ? 'w' : 'b'
    castling_rights = board.castling_rights.to_s
    en_passant_pos = board.en_passant_square.nil? ? '-' : board.en_passant_square.to_s
    halfmove = board.halfmove_clock.to_s
    fullmove = board.fullmove_no.to_s
    
    [pieces, active, castling_rights, en_passant_pos, halfmove, fullmove].join(' ')
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
    letter = piece.color == :white ? letter.upcase : letter
    result + letter
  end

  def initialize(fen_notation = DEFAULT_NOTATION)
    segments = fen_notation.split(' ')
    raise ChessError unless segments.size == 6
    
    @pieces = segments[0]
    @active = segments[1]
    @castling_rights = segments[2]
    @en_passant_pos = segments[3]
    @halfmove = segments[4]
    @fullmove = segments[5]
  end
  
  def parse
    {
      pieces: parse_pieces,
      active_color: active == 'w' ? :white : :black,
      castling_rights: parse_castling_rights,
      en_passant_square: en_passant_pos == '-' ? nil : Position.parse(en_passant_pos),
      halfmove_clock: halfmove.to_i,
      fullmove_no: fullmove.to_i
    }
  end
  
  private
  
  attr_reader :pieces, :active, :castling_rights, :en_passant_pos, :halfmove, :fullmove
  
  def parse_castling_rights
    res = CastlingRights.new

    res.kingside[:white] = true if castling_rights.include?('K')
    res.kingside[:black] = true if castling_rights.include?('k')
    res.queenside[:white] = true if castling_rights.include?('Q')
    res.queenside[:black] = true if castling_rights.include?('q')
    
    res
  end
  
  def parse_pieces
    ranks = pieces.split('/')
    raise ChessError, ERROR_MESSAGES[:invalid_board_height] if ranks.length != BOARD_HEIGHT
    
    ranks.each_with_index.reduce([]) { |res, (rank, y)| res.concat parse_rank_fen(rank, y) }
  end
  
  def parse_rank_fen(rank_fen, y)
    tokens = rank_fen.split('')
    pos = Position.new(y: y, x: -1)

    pieces = tokens.reduce([]) do |res, token|
      piece, pos = parse_token(token, pos)
      res.push(piece)
    end
    
    raise ChessError, ERROR_MESSAGES[:invalid_board_width] if pos.x + 1 != BOARD_WIDTH
    pieces.reject(&:nil?)
  end
  
  def parse_token(token, pos)
    raise ChessError, ERROR_MESSAGES[:invalid_token] unless FEN_TOKEN_REGEX.match(token)

    if is_integer? token
      pos = pos.increment(x: token.to_i)
      piece = nil
    else
      color = token.upcase == token ? :white : :black
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

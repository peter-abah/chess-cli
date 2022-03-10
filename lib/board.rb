# frozen_string_literal: true

require 'require_all'
require_relative './letter_display'
require_relative './fen_parser'
require_rel 'pieces'

# A class to represent a chess board
class Board
  include LetterDisplay

  DEFAULT_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0'

  attr_reader :pieces, :active_color, :en_passant_square, :halfmove_clock, :fullmove_no

  def initialize(fen_notation: DEFAULT_FEN, segments: nil)
    segments ||= FENParser.new(fen_notation).parse
    @pieces = segments[:pieces].freeze
    @active_color = segments[:active_color]
    @castling_rights = segments[:castling_rights]
    @en_passant_square = segments[:en_passant_square]
    @halfmove_clock = segments[:halfmove_clock]
    @fullmove_no = segments[:fullmove_no]
  end

  def update(move)
    segments = {
      pieces: update_pieces(move),
      active_color: active_color == :white ? :black : white,
      castling_rights: update_castling_rights(move),
      en_passant_square: update_en_passant_square(move),
      halfmove_clock: update_halfmove_clock(move),
      fullmove_no: active_color == :black ? fullmove_no + 1 : fullmove_no
    }

    Board.new(segments: segments)
  end

  def player_pieces(color)
    pieces.select { |piece| piece.color == color }
  end

  def piece_at(pos, piecesn: pieces)
    piecesn.find { |piece| piece.position == pos }
  end
  
  def can_castle_kingside?(color)
    castling_rights.kingside[color]
  end
  
  def can_castle_queenside?(color)
    castling_rights.queenside[color]
  end

  private
  
  attr_reader :castling_rights
  
  def update_castling_rights
    new_castling_rights = castling_rights.dup
    
    new_castling_rights.kingside[:white] = invalidate_kingside_castling? move, :white
    new_castling_rights.queenside[:white] = invalidate_queenside_castling? move, :white
    
    new_castling_rights.kingside[:black] = invalidate_kingside_castling? move, :black
    new_castling_rights.queenside[:black] = invalidate_queenside_castling? move, :black
    
    new_castling_rights
  end
  
  def invalidate_kingside_castling?(move, color)
    if color == active_color
      move.from.king_pos?(color) || move.from.kingside_rook_pos?(color)
    elsif move.removed
      move.removed.kingside_rook_pos?(color)
    end
  end
  
  def invalidate_queenside_castling?(move, color)
    if color == active_color
      move.from.king_pos?(color) || move.from.queenside_rook_pos?(color)
    elsif move.removed
      move.removed.queenside_rook_pos?(color)
    end
  end
  
  def update_pieces(move)
    pieces = remove_piece(move)
    move_pieces(pieces, move)
  end
  
  def update_en_passant_square(move)
    move.moved.reduce('-') do |res, hash|
      en_passant_possible?(hash) ? hash[:to].to_s : res
    end
  end
  
  def update_halfmove_clock(move)
    move.moved.reduce(false) do |increase_clock, hash|
      piece = piece_at(hash[:from])
      piece.is_a? Pawn ? true : increase_clock
    end
    
    moved.removed || increase_clock ? halfmove_clock + 1 : 0
  end

  def en_passant_possible(hash)
    piece = piece_at(hash[:from])

    piece.is_a?(Pawn) && hash[:from].starting_pawn_rank(piece.color) &&
      hash[:to].en_passant_rank?(piece.color)
  end   

  def remove_piece(move)
    return pieces.dup unless move.removed
    
    pieces.reject { |piece| piece.position == move.removed }
  end

  def move_pieces(pieces, move)
    move.moved.map do |hash|
      piece = move_piece(pieces, hash)
      piece = promote_piece(pieces, hash[:to], move.promotion) if move.promotion
      pieces = pieces.reject { |piece| piece.position == hash[:from] }
    end
  end

  def move_piece(pieces, hash)
    piece = piece_at(hash[:from], pieces: pieces)
    piece.update_position(hash[:to])
  end

  def promote_piece(pieces, pos, piece_letter)
    piece_class = LETTER_TO_PIECE_CLASS[piece_letter.downcase.to_sym]
    color = piece_at(piece_pos).color
    piece_class.new(color, pos)
  end
end

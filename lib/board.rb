# frozen_string_literal: true

require 'require_all'

require_relative 'fen_parser'
require_relative 'position'
require_relative 'errors'
require_relative 'letter_display'
require_rel 'pieces/pawn', 'pieces/piece_constants'

# A class to represent a chess board
class Board
  include LetterDisplay
  include PieceConstants

  attr_reader :pieces, :active_color, :en_passant_square, :halfmove_clock, :fullmove_no, :castling_rights

  def initialize(fen_notation: nil, segments: nil)
    segments ||= fen_notation ? FENParser.new(fen_notation).parse : FENParser.new.parse
    @pieces = segments[:pieces].freeze
    @active_color = segments[:active_color]
    @castling_rights = segments[:castling_rights]
    @en_passant_square = segments[:en_passant_square]
    @halfmove_clock = segments[:halfmove_clock]
    @fullmove_no = segments[:fullmove_no]
  end

  def make_move(move)
    segments = {
      pieces: update_pieces(move),
      active_color: active_color == :white ? :black : :white,
      castling_rights: update_castling_rights(move),
      en_passant_square: update_en_passant_square(move),
      halfmove_clock: update_halfmove_clock(move),
      fullmove_no: active_color == :black ? fullmove_no + 1 : fullmove_no
    }

    self.class.new(segments: segments)
  end

  def player_pieces(color)
    pieces.select { |piece| piece.color == color }
  end
  
  def opponent_color
    active_color == :white ? :black : :white
  end

  def piece_at(pos, pieces_n: pieces)
    pos = Position.parse(pos) unless pos.is_a? Position

    pieces_n.find { |piece| piece.position == pos }
  end
  
  def can_castle_kingside?(color)
    castling_rights.kingside[color]
  end
  
  def can_castle_queenside?(color)
    castling_rights.queenside[color]
  end
  
  def to_fen
    FENParser.board_to_fen self
  end
  
  def to_s
    to_fen
  end

  private
  
  def update_castling_rights(move)
    new_castling_rights = castling_rights.dup
    
    new_castling_rights.kingside[:white] = invalidate_kingside_castling(move, :white)
    new_castling_rights.queenside[:white] = invalidate_queenside_castling(move, :white)
    
    new_castling_rights.kingside[:black] = invalidate_kingside_castling(move, :black)
    new_castling_rights.queenside[:black] = invalidate_queenside_castling(move, :black)
    
    new_castling_rights
  end
  
  def invalidate_kingside_castling(move, color)
    invalidate = move.moved.all? do |hash|
      if color == active_color
        hash[:from].king_pos?(color) || hash[:from].kingside_rook_pos?(color)
      elsif move.removed
        move.removed.kingside_rook_pos?(color)
      end
    end
    
    castling_rights.kingside[color] && !invalidate
  end
  
  def invalidate_queenside_castling(move, color)
    invalidate = move.moved.all? do |hash|
      if color == active_color
        hash[:from].king_pos?(color) || hash[:from].queenside_rook_pos?(color)
      elsif move.removed
        move.removed.queenside_rook_pos?(color)
      end
    end
    
    castling_rights.queenside[color] && !invalidate
  end
  
  def update_pieces(move)
    pieces = remove_piece(move)
    move_pieces(pieces, move)
  end
  
  def update_en_passant_square(move)
    move.moved.reduce('-') do |res, hash|
      if en_passant_possible?(hash)
        direction = piece_at(hash[:from]).direction
        return hash[:to].increment(y: -direction)
      end
      
      res
    end
  end
  
  def update_halfmove_clock(move)
    reset_clock = move.moved.reduce(false) do |res, hash|
      piece = piece_at(hash[:from])
      piece.is_a?(Pawn) ? true : res
    end
    
    move.removed || reset_clock ? 0 : halfmove_clock + 1
  end

  def en_passant_possible?(hash)
    piece = piece_at(hash[:from])

    piece.is_a?(Pawn) && hash[:from].starting_pawn_rank?(piece.color) &&
      hash[:to].en_passant_rank?(piece.color)
  end   

  def remove_piece(move)
    return pieces.dup unless move.removed
    raise ChessError, 'Cannot remove your own piece' if piece_at(move.removed).color == active_color

    pieces.reject { |piece| piece.position == move.removed }
  end

  def move_pieces(pieces, move)
    move.moved.reduce(pieces) do |res, hash|
      piece = move_piece(res, hash)
      piece = promote_piece(pieces, hash, move.promotion) if move.promotion
      res = res.reject { |piece| piece.position == hash[:from] }
      res.push(piece)
    end
  end

  def move_piece(pieces, hash)
    piece = piece_at(hash[:from], pieces_n: pieces)
    raise ChessError, 'Can only move your own piece' unless piece.color == active_color

    piece.update_position(hash[:to])
  end

  def promote_piece(pieces, hash, piece_letter)
    piece_class = LETTER_TO_PIECE_CLASS[piece_letter.downcase.to_sym]
    color = piece_at(hash[:from], pieces_n: pieces).color
    piece_class.new(color, hash[:to])
  end
end

# frozen_string_literal: true

require_relative '../position'
require_relative '../pieces/piece_constants'
require_relative '../move'

# a module to generate moves for a piece
module MoveGenerator
  include PieceConstants

  SPECIAL_MOVES = {
    castle: :castle_moves,
    en_passant: :en_passant_moves,
  }.freeze

  def moves_for_pos(pos, board)
    piece = board.piece_at pos
    return [] unless piece&.color == board.active_color

    moves_for_piece(piece, board)
  end

  def moves_for_piece(piece, board)
    piece.move_sets.reduce([]) do |result, move_set|
      move_set.increments.each do |increment|
        result.concat(
          gen_moves_for_increment(board, move_set, increment, piece)
        )
      end

      result.concat gen_special_moves(board, move_set, piece)
    end
  end
  
  private
  
  def gen_moves_for_increment(board, move_set, increment, piece)
    x, y = increment.values_at(:x, :y)
    result = []

    1.upto(move_set.repeat) do |factor|
      new_pos = piece.position.increment(y: y * factor, x: x * factor)
      if new_pos.out_of_bounds? || blocked?(board, move_set, piece, new_pos)
        break
      end
      
      removed = board.piece_at(new_pos).nil? ? nil : new_pos.to_s
      from = piece.position.to_s
      to = new_pos.to_s

      if move_set.promotable && piece.can_promote?(new_pos)
        result.concat promotion_moves(piece, from: from, to: to, removed: removed)
      else
        result << Move.new(from: from, to: to, removed: removed)
      end
      
      break unless removed.nil?
    end
    
    result
  end
  
  def promotion_moves(piece, from:, to:, removed:)
    piece.promotion_pieces.map do |letter| 
      Move.new(from: from, to: to, removed: removed, promotion: letter)
    end
  end
  
  def blocked?(board, move_set, piece, new_pos)
    other_piece = board.piece_at new_pos
    return true if other_piece.nil? && move_set.blocked_by.include?(:empty)
    
    return true if other_piece && move_set.blocked_by.include?(:piece)
    
    return true if other_piece&.color == piece.color && move_set.blocked_by.include?(:same)

    return true if other_piece&.color != piece.color && move_set.blocked_by.include?(:enemy)    
    
    false
  end
  
  def gen_special_moves(board, move_set, piece)
    result = []
    move_set.special_moves.each do |sym|
      result.concat self.send(SPECIAL_MOVES[sym], board, piece)
    end
    
    result.reject(&:nil?)
  end
  
  def castle_moves(board, piece)
    [
      kingside_castle_move(board, piece),
      queenside_castle_move(board, piece)
    ].reject(&:nil?)
  end
  
  def en_passant_moves(board, piece)
    moves = [-1, 1].map do |x|
      from = piece.position
      to = piece.position.increment(y: piece.direction, x: x)
      removed = piece.position.increment(x: x)
      next nil unless board.en_passant_square == to 

      Move.new(from: from.to_s, to: to.to_s, removed: removed.to_s)
    end
    
    moves.reject(&:nil?)
  end
  
  def kingside_castle_move(board, piece)
    return unless board.can_castle_kingside? piece.color

    return unless kingside_castle_squares_available?(board, piece)
    
    king_from = piece.position.to_s
    king_to = piece.position.increment(x: 2).to_s
    rook_from = piece.color == :white ? 'h1' : 'h8'
    rook_to = piece.color == :white ? 'f1' : 'f8'

    move = Move.new(from: king_from, to: king_to, castle: :kingside)
    move.add_move(from: rook_from, to: rook_to)
    move
  end
  
  def queenside_castle_move(board, piece)
    return unless board.can_castle_queenside? piece.color

    return unless queenside_castle_squares_available?(board, piece)
    
    king_from = piece.position.to_s
    king_to = piece.position.increment(x: -2).to_s
    rook_from = piece.color == :white ? 'a1' : 'a8'
    rook_to = piece.color == :white ? 'd1' : 'd8'

    move = Move.new(from: king_from, to: king_to, castle: :queenside)
    move.add_move(from: rook_from, to: rook_to)
    move
  end
  
  def kingside_castle_squares_available?(board, piece)
    positions = piece.color == :white ? %w[f1 g1] : %w[f8 g8]
    positions.all? do |pos|
      board.piece_at(pos).nil?
    end
  end
  
  def queenside_castle_squares_available?(board, piece)
    positions = piece.color == :white ? %w[b1 c1 d1] : %w[b8 c8 g8]
    positions.all? do |pos|
      board.piece_at(pos).nil?
    end
  end
end

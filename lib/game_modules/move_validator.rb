# frozen_string_literal: true

require_relative 'move_generator'

module MoveValidator
  include MoveGenerator

  def legal_move?(move)
    new_board = board.make_move move
    is_check = check?(boardn: new_board, color: current_player)
    
    if move.castle
      return !is_check && legal_castle_move?(move)
    end
    
    !is_check
  end
  
  def check?(boardn: board, color: current_player)
    king = boardn.pieces.find { |piece| piece.is_a?(King) && piece.color == color }
    king ? pos_attacked?(boardn, king.position, color) : false
  end
  
  def legal_castle_move?(move)
    move.castle == :kingside ? legal_kingside_castle_move? : legal_queenside_castle_move?
  end
  
  def legal_kingside_castle_move?
    positions = current_player == :white ? %w[f1 g1] : %w[f8 g8]
    positions.none? { |pos| pos_attacked?(board, Position.parse(pos), current_player) }
  end
  
  def legal_queenside_castle_move?
    positions = current_player == :white ? %w[b1 c1 d1] : %w[b8 c8 d8]
    positions.none? { |pos| pos_attacked?(board, Position.parse(pos), current_player) }
  end
  
  def pos_attacked?(board, pos, color)
    opponent_color = color == :white ? :black : :white
    pieces = board.player_pieces(opponent_color)
    moves = pieces.reduce([]) { |res, piece| res.concat moves_for_piece(piece, board) }
    moves.any? do |move|
      move.removed == pos
    end
  end
end
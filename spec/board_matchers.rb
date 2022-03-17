# frozen_string_literal: true

require 'pry-byebug'
require 'rspec/expectations'
require 'require_all'

require_rel '../lib/rb_chess/pieces'
require_relative '../lib/rb_chess/position'

RSpec::Matchers.define :have_all_pieces_at_default_positions do
  match do |pieces|
    has_rooks?(pieces) && has_knights?(pieces) && has_bishops?(pieces) &&
    has_queens?(pieces) && has_kings?(pieces) && has_pawns?(pieces) &&
    pieces.size == 32
  end
  
  def has_rooks?(pieces)
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Rook, positions: ['a1', 'h1'], color: :white
    )
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Rook, positions: ['a8', 'h8'], color: :black
    )
  end
  
  def has_bishops?(pieces)
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Bishop, positions: ['c1', 'f1'], color: :white
    )
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Bishop, positions: ['c8', 'f8'], color: :black
    )
  end
  
  def has_knights?(pieces)
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Knight, positions: ['b1', 'g1'], color: :white
    )
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Knight, positions: ['b8', 'g8'], color: :black
    )
  end
  
  def has_queens?(pieces)
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Queen, positions: ['d1'], color: :white
    )
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Queen, positions: ['d8'], color: :black
    )
  end
  
  def has_kings?(pieces)
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::King, positions: ['e1'], color: :white
    )
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::King, positions: ['e8'], color: :black
    )
  end
  
  def has_pawns?(pieces)
    white_pawn_positions = ('a'..'h').map { |letter| "#{letter}2" }
    black_pawn_positions = ('a'..'h').map { |letter| "#{letter}7" }

    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Pawn, positions: white_pawn_positions, color: :white
    )
    has_piece_of_type?(
      pieces: pieces, klass: RbChess::Pawn, positions: black_pawn_positions, color: :black
    )
  end
  
  def has_piece_of_type?(pieces:, klass:, positions:, color:)
    positions.all? do |pos|
      pieces.any? do |piece|
        piece.color == color && 
        piece.position == RbChess::Position .parse(pos) &&
        piece.is_a?(klass)
      end
    end
  end
end

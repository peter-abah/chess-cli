# frozen_string_literal: true

require 'require_all'
require_rel './'

module RbChess
  module PieceConstants
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
  end
end

# frozen_string_literal: true

require_relative 'position'
require_relative 'pieces/piece_constants'

# A module to display chess board on console
module RbChess
  module LetterDisplay
    include PieceConstants

    COLUMN_LABELS = '   a b c d e f g h'
    SEPARATOR = '  _________________'

    def ascii
      ranks = (0..7).map { |rank_no| rank_ascii(rank_no) }
      result = [COLUMN_LABELS, SEPARATOR] + ranks + [SEPARATOR, COLUMN_LABELS]
      result.join("\n")
    end

    private

    def rank_ascii(rank_no)
      result = (0..7).map do |file_no|
        piece_ascii(rank_no, file_no)
      end

      result.unshift("#{8 - rank_no} ")
      result.push(" #{8 - rank_no}")
      result.join(' ')
    end

    def piece_ascii(rank_no, file_no)
      pos = Position.new(y: rank_no, x: file_no)
      piece = piece_at(pos)
      return '-' if piece.nil?

      key = piece.class.name.split('::').last.to_sym
      result = PIECE_CLASS_TO_LETTER[key]
      piece.color == :black ? result.downcase : result.upcase
    end
  end
end

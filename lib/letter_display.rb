# frozen_string_literal: true

require_relative 'position'
require_relative 'pieces/piece_constants'

# A module to display chess board on console
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

    result.unshift("#{rank_no + 1} ")
    result.push(" #{rank_no + 1}")
    result.join(' ')
  end

  def piece_ascii(rank_no, file_no)
    pos = Position.new(y: rank_no, x: file_no)
    piece = piece_at(pos)
    return '-' if piece.nil?

    result = PIECE_CLASS_TO_LETTER[piece.class.name.to_sym]
    piece.color == :black ? result.downcase : result.upcase
  end
end

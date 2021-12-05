# frozen_string_literal: true

# A module to display chess board on console
module Display
  COLUMN_LABELS = '   a b c d e f g h'
  SEPARATOR = '  _________________'
  LETTER_MAPPING = {
    Pawn: 'P',
    Rook: 'R',
    Knight: 'N',
    Bishop: 'B',
    Queen: 'Q',
    King: 'K'
  }.freeze

  def board_representation(board)
    ranks = (0..7).map { |rank_no| rank_representation(board, rank_no) }
    board_repr = [COLUMN_LABELS, SEPARATOR] + ranks + [SEPARATOR, COLUMN_LABELS]
    board_repr.join("\n")
  end

  def rank_representation(board, rank_no)
    rank_repr = (0..7).map do |file_no|
      piece_representation(board, rank_no, file_no)
    end

    rank_repr.unshift("#{rank_no + 1} ")
    rank_repr.push(" #{rank_no + 1}")
    rank_repr.join(' ')
  end

  def piece_representation(board, rank_no, file_no)
    piece = board.piece_at(y: rank_no, x: file_no)
    return '-' if piece.nil?

    piece_repr = LETTER_MAPPING[piece.class.name.to_sym]
    piece.color == 'black' ? piece_repr.downcase : piece_repr
  end
end

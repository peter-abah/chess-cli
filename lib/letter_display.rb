# frozen_string_literal: true

# a module to display the chess board nicely with letters
module LetterDisplay
  LETTER_MAPPING = {
    Pawn => 'P',
    Rook => 'R',
    Knight => 'N',
    Bishop => 'B',
    Queen => 'Q',
    King => 'K'
  }.freeze

  def display
    result = []
    board_array.each do |row|
      result.push(create_row(row))
    end

    result.join("\n")
  end

  def create_row(row)
    result = []
    row.each do |piece|
      result.push('-') && next if piece.nil?

      prefix = piece.color[0].upcase
      str = prefix + LETTER_MAPPING[piece.class]
      result.push(str)
    end

    result.join(' ')
  end
end

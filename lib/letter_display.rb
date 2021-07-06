# frozen_string_literal: true

# a module to display the chess board nicely with letters
module LetterDisplay
  LETTER_MAPPING = {
    'Pawn' => 'P',
    'Rook' => 'R',
    'Knight' => 'N',
    'Bishop' => 'B',
    'Queen' => 'Q',
    'King' => 'K'
  }.freeze

  COLUMN_LABELS = '   a  b  c  d  e  f  g  h  '

  def display
    result = [COLUMN_LABELS, "\n"]
    board_array.each_with_index do |row, i|
      i = 8 - i
      result.push(create_row(row, i))
    end

    result.push("\n", COLUMN_LABELS)
    puts result.join("\n")
  end

  def create_row(row, i)
    result = ["#{i} "]
    row.each do |piece|
      result.push('--') && next if piece.nil?

      prefix = piece.color[0].upcase
      str = prefix + LETTER_MAPPING[piece.class.name]
      result.push(str)
    end

    result.push(" #{i}")
    result.join(' ')
  end
end

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

  UNICODE_DISPLAY = {
    'white' => {
      'Pawn' => "\u2659",
      'Rook' =>  "\u2656",
      'Knight' => "\u2658",
      'Bishop' => "\u2657",
      'Queen' => "\u2655",
      'King' => "\u2654"
    },
    'black' => {
      'Pawn' => "\u265F",
      'Rook' =>  "\u265C",
      'Knight' => "\u265E",
      'Bishop' => "\u265D",
      'Queen' => "\u265B",
      'King' => "\u265A"
    }
  }

  COLUMN_LABELS = '   a b c d e f g h  '

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
      result.push('-') && next if piece.nil?

      color = piece.color
      str = LETTER_MAPPING[piece.class.name]
      str = color == 'white' ? str.upcase : str.downcase
      result.push(str)
    end

    result.push(" #{i}")
    result.join(' ')
  end
end

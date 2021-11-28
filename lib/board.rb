# frozen_string_literal: true

require 'require_all'
require_relative './letter_display'
require_relative './fen_parser'
require_rel 'pieces'

# A class to represent a chess board
class Board
  include LetterDisplay

  DEFAULT_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'

  attr_reader :board_array, :prev_board_array

  def initialize(board_array = nil, prev_board_array = nil, board_fen: DEFAULT_FEN, prev_state: nil)
    @pieces = { 'white' => {}, 'black' => {} }

    @board_array = board_array || FENParser.new(board_fen).parse
    @prev_board_array = prev_board_array

    update_pieces_positions
  end

  def update(move)
    new_board_array = board_array.map(&:dup)

    remove_piece(new_board_array, move)
    move_pieces(new_board_array, move)

    Board.new(new_board_array, board_array)
  end

  def player_pieces(color)
    @pieces[color]
  end

  def piece_at(y:, x:)
    board_array[y][x]
  end

  private

  def remove_piece(array, move)
    return unless move.removed

    y, x = move.removed
    array[y][x] = nil
  end

  def move_pieces(array, move)
    move.moved.each do |piece_pos, new_pos|
      move_piece(array, piece_pos, new_pos)
      promote_piece(array, new_pos, move.promotion)
    end
  end

  def move_piece(array, piece_pos, new_pos)
    y, x = piece_pos
    piece = array[y][x]
    array[y][x] = nil

    y, x = new_pos
    array[y][x] = piece
    piece.has_moved = true
  end

  def promote_piece(array, piece_pos, piece_class)
    return unless piece_class

    y, x = piece_pos
    color = array[y][x].color
    array[y][x] = piece_class.new(color)
  end

  def create_board_array
    array = Array.new(8) { Array.new(8) }

    array[0] = pieces_array('black')
    array[1] = pawn_array('black')

    array[6] = pawn_array('white')
    array[7] = pieces_array('white')

    array
  end

  def pieces_array(color)
    array = []

    array.concat(side_pieces(color))
    array.push(Queen.new(color))
    array.push(King.new(color))

    array.concat(side_pieces(color).reverse)
  end

  def side_pieces(color)
    array = Array.new(3)

    array[0] = Rook.new(color)
    array[1] = Knight.new(color)
    array[2] = Bishop.new(color)

    array
  end

  def pawn_array(color)
    Array.new(8) { Pawn.new(color) }
  end

  def update_pieces_positions
    0.upto(7) do |y|
      0.upto(7) do |x|
        piece = board_array[y][x]
        next if piece.nil?

        @pieces[piece.color][piece] = [y, x]
      end
    end
  end
end

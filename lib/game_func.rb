# frozen_string_literal: true

require_relative 'pieces/king'
require_relative 'board'

# A module for game class functions that will be used by other classes
module GameFunc
  PROMOTION_CHOICES = {
    1 => Queen,
    2 => Rook,
    3 => Bishop,
    4 => Knight,
    5 => Pawn
  }

  def valid_moves(board, player)
    pieces = board.player_pieces(player.color)
    result = pieces.reduce([]) do |moves, (piece, pos)|
      moves + piece.possible_moves(board, pos)
    end
    result.select { |move| legal_move?(move, player, board) }
  end

  def legal_move?(move, player, board)
    move.promotion = Queen if move.promotion
    new_board = board.update(move)
    return false if check?(player, new_board)

    move.castle ? legal_castle_move?(player, board) : true
  end

  def legal_castle_move?(player, board)
    return false if check?(player, board)

    king_pos = player.color == 'white' ? [7, 4] : [0, 4]
    new_board = move_piece_sideways_by(x_amount: 1, piece_pos: king_pos, board: board)
    return false if check?(player, new_board)

    new_board = move_piece_sideways_by(x_amount: 2, piece_pos: king_pos, board: board)
    !check?(player, new_board)
  end

  def move_piece_sideways_by(x_amount:, piece_pos:, board:)
    y, x = piece_pos
    move = Move.new(piece_pos, [y, x + x_amount])
    board.update(move)
  end

  def check?(player, board)
    board_array = board.board_array

    moves = opponent_moves(player, board)
    moves.each do |move|
      next unless move.removed

      y, x = move.removed
      return true if board_array[y][x].is_a? King
    end

    false
  end

  def opponent_moves(player, board)
    result = []

    pieces = opponent_pieces(player.color, board)
    pieces.each do |piece, pos|
      move = piece.possible_moves(board, pos)
      result.concat(move)
    end

    result
  end

  def opponent_pieces(color, board)
    opponent_color = color == 'white' ? 'black' : 'white'
    board.player_pieces(opponent_color)
  end
end

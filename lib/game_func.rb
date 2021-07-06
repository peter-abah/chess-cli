# frozen_string_literal: true

require_relative 'pieces/king'
require_relative 'board'

# A module for game class functions that will be used by other classes
module GameFunc
  def legal_move?(move, player, board)
    new_board = board.update(move)
    return false if check?(player, new_board)

    move.castle ? legal_castle_move?(move, player, board) : true
  end

  def legal_castle_move?(player, board)
    return false if check?(player, board)

    y, x = player.color == 'white' ? [7, 4] : [0, 4]

    new_board = move_piece(board.board_array, y, x)
    return false if check?(player, new_board)

    new_board = move_piece(new_board.board_array, y, x + 1)
    !check?(player, new_board)
  end

  def move_piece(board_array, y, x)
    board_array[y][x + 1] = board_array[y][x]
    board_array[y][x] = nil
    Board.new(board_array)
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

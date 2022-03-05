# frozen_string_literal: true|

# a module to generate moves for queen, bishop and rook
module MoveGenerator
  def gen_moves(board_array, pos)
    result = []

    directions.each do |dir|
      moves = valid_moves(board_array, pos, dir)
      result.concat(moves)
    end

    result
  end

  def valid_moves(board_array, pos, step)
    result = []
    yn, xn = step
    new_pos = [pos[0] + yn, pos[1] + xn]

    while valid_move?(board_array, new_pos)
      move = gen_move(board_array, pos, new_pos)
      result.push(move)
      break if move.removed

      new_pos = [new_pos[0] + yn, new_pos[1] + xn]
    end
    result
  end

  def valid_move?(board_array, pos)
    y, x = pos
    return false unless y.between?(0, 7) && x.between?(0, 7)

    board_array[y][x].nil? || board_array[y][x].color != color
  end

  def gen_move(board_array, pos, new_pos)
    move = Move.new(pos, new_pos)

    y, x = new_pos
    piece = board_array[y][x]
    move.removed = new_pos unless piece.nil? || piece.color == color

    move
  end
end

# frozen_string_literal: true

require_relative 'move_generator'

module MoveParser
  include MoveGenerator

  MOVE_REGEX = /^(0-0)|(0-0-0)|(([a-h][1-8]){2}[qrbn]?)$/i

  def parse_move(move)
    unless MOVE_REGEX.match move
      raise ArgumentError, "Invalid move format cannot parse: #{move}"
    end
    
    castling_move?(move) ? castling_move(move) : normal_move(move)
  end
  
  def castling_move?(move)
    /(0-0)|(0-0-0)/.match move
  end
  
  def castling_move(move)
    pos = current_player == :white ? 'e1' : 'e8'
    type = move == '0-0' ? :kingside : :queenside

    moves = moves_for_pos(pos, board)
    move = moves.select { |m| m.castle == type }
    
    raise ArgumentError, "Invalid move, cannot castle #{type}" unless move
    move
  end
  
  def normal_move(move_str)
    _, pos, to, promotion = * /^(\w{2})(\w{2})(\w?)$/.match(move_str)
    moves = moves_for_pos(pos, board)
    move = moves.find { |m| m.to_s.downcase == move_str.downcase }
    raise ArgumentError, "Invalid move: #{move}" unless move
    
    move
  end
end

# frozen_string_literal: true

require 'json'
require 'require_all'

require_relative 'board'
require_relative 'errors'
require_rel 'game_modules'

# A class to handle a chess game
module RbChess
  class Game
    include MoveGenerator
    include MoveParser
    include MoveValidator

    attr_reader :board

    def initialize(fen: nil)
      @board = Board.new(fen_notation: fen)
      @starting_board = @board
      @history = [].freeze
      @repetitions_count = Hash.new(0) # for threefold repetition rule
    end

    def make_move(move)
      raise ChessError, 'Game Over' if game_over?

      move = parse_move move
      raise ChessError, 'Cannot make move king in check' unless legal_move? move

      @board = board.make_move move
      @history = [*@history, move].freeze
      update_repetitions_count
    end

    def valid_move?(move)
      move = parse_move move
      legal_move? move
    rescue ChessError
      false
    end

    def all_moves
      moves = board.player_pieces(current_player).reduce([]) do |res, piece|
        res.concat moves_for_piece(piece, board)
      end
      moves.filter { |m| legal_move?(m) }.map(&:to_s)
    end

    def make_moves(moves)
      moves.each { |m| make_move(m) }
    end

    def moves_at(pos)
      moves_for_pos(pos, board).filter { |m| legal_move?(m) }.map(&:to_s)
    end

    def current_player
      board.active_color
    end

    def stalemate?
      no_moves?
    end

    def threefold?
      repetitions_count.values.any? { |e| e >= 3 }
    end

    def fivefold?
      repetitions_count.values.any? { |e| e >= 5 }
    end

    def seventy_five_moves?
      board.halfmove_clock >= 150
    end

    def history
      @history.map(&:to_s)
    end

    def fifty_moves?
      board.halfmove_clock >= 100
    end

    def checkmate?
      stalemate? && check?
    end

    def insufficient_material?
      return true if board.pieces.size == 2 # only kings

      return true if board.pieces.size == 3 &&
                     board.pieces.any? { |p| p.is_a?(Knight) || p.is_a?(Bishop) }

      if board.pieces.size == 4
        bishops = board.pieces.select { |p| p.is_a? Bishop }
        return bishops.length == 2 &&
               bishops[0].position.square_type == bishops[1].position.square_type
      end

      false
    end

    def draw?
      !checkmate? && (
        stalemate? || fivefold? || insufficient_material? ||
        seventy_five_moves?
      )
    end

    def game_over?
      checkmate? || draw?
    end

    def serialize
      Marshal.dump(self)
    end

    def self.deserialize(data)
      Marshal.load(data)
    end

    def as_json
      data = {
        moves: history,
        starting_fen: starting_board.to_fen,
        fen: board.to_fen
      }
      JSON.generate(data)
    end

    def self.from_json(json_data, with_history: false)
      data = JSON.parse(json_data)
      return new(fen: data['fen']) unless with_history

      game = new(fen: data['starting_fen'])
      game.make_moves data['moves']
      game
    end

    private

    def update_repetitions_count
      # removes halfmove and fullmove since they are needed
      board_fen = board.to_fen.split(' ').first(4).join(' ')
      repetitions_count[board_fen] = repetitions_count[board_fen] + 1
    end

    def no_moves?
      moves = board.player_pieces(current_player).reduce([]) do |res, piece|
        res.concat moves_for_piece(piece, board)
      end
      moves.none? { |m| legal_move?(m) }
    end

    attr_reader :repetitions_count, :starting_board
  end
end

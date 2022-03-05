# frozen_string_literal: true

require_relative '../lib/pieces/pawn'
require_relative '../lib/board'

describe Pawn do
  subject(:pawn) { described_class.new('white') }

  describe '#initialize' do
    context 'when called with one argument' do
      let(:color) { 'white' }
      subject(:pawn) { described_class.new(color) }
    end
  end

  describe '#move_sets' do
    it 'returns the correct move_sets' do
      move_set, = pawn.move_sets
      expected_directions = [{ y: -1, x: 0 }]

      expect(pawn.move_sets.size).to eq 1
      expect(move_set.directions).to eq expected_directions
      expect(move_set.repeat).to eq 2
      expect(move_set.blocked_by).to eq :all
      expect(move_set.special_moves).to eq %i[en_passant pawn_capture promotion]
    end

    context 'when color is different' do
      subject(:pawn) { described_class.new('black') }

      it 'returns move_set with different directions' do
        move_set, = pawn.move_sets
        expected_directions = [{ y: 1, x: 0 }]
        expect(move_set.directions).to eq expected_directions
      end
    end

    xcontext 'when the pawn has moved' do
      subject(:pawn) { described_class.new('white') }

      before { pawn.has_moved = true }

      it 'returns move_set with repeat as 1' do
        move_set, = pawn.move_sets
        expect(move_set.repeat).to eq 1
      end
    end
  end

  # describe '#possible_moves' do
  #   context 'when called with a board at default position' do
  #     let(:board) { Board.new }
  #     let(:pawn) { board.piece_at(y: 6, x: 3) }

  #     it 'returns an array of Move objects' do
  #       array = pawn.possible_moves(board, [6, 3])
  #       result = array.all? { |e| e.is_a? Move }
  #       expect(result).to eq(true)
  #     end

  #     it 'returns the correct moves' do
  #       expected = [{ [6, 3] => [5, 3] }, { [6, 3] => [4, 3] }]

  #       moves = pawn.possible_moves(board, [6, 3])
  #       result = moves.map(&:moved)
  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when called with the pawn at third rank' do
  #     let(:board) { Board.new(fen_notation: '8/8/8/8/8/3P4/8/8') }
  #     subject(:pawn) { board.piece_at(y: 5, x: 3) }

  #     it 'returns the correct moves' do
  #       expected = [{ [5, 3] => [4, 3] }]

  #       array = pawn.possible_moves(board, [5, 3])
  #       result = array.map(&:moved)
  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there is a chess piece blocking it' do
  #     let(:board) { Board.new(fen_notation: '8/8/8/8/8/3P4/3P4/8') }
  #     subject(:pawn) { board.piece_at(y: 6, x: 3) }

  #     it 'returns an empty array' do
  #       array = pawn.possible_moves(board, [6, 3])
  #       expect(array).to be_empty
  #     end
  #   end

  #   context 'when there is an enemy piece diagonal to it' do
  #     let(:board) { Board.new(fen_notation: '8/8/8/8/8/4p3/3P4/8') }
  #     subject(:pawn) { board.piece_at(y: 6, x: 3) }

  #     it 'returns the correct move' do
  #       expected = [{ [6, 3] => [5, 3] }, { [6, 3] => [4, 3] }, { [6, 3] => [5, 4] }]

  #       array = pawn.possible_moves(board, [6, 3])
  #       result = array.map(&:moved)
  #       expect(result).to eq(expected)
  #     end

  #     it 'returns a move that leads to capture of piece' do
  #       array = pawn.possible_moves(board, [6, 3])
  #       result = array.any? { |e| e.removed == [5, 4] }
  #       expect(result).to be true
  #     end
  #   end

  #   context 'when there is a piece blocking it but there are two enemy pieces in its front diagonal' do
  #     let(:board) { Board.new(fen_notation: '8/8/8/8/8/2ppp3/3P4/8') }
  #     subject(:pawn) { board.piece_at(y: 6, x: 3) }

  #     it 'returns the correct move' do
  #       expected = [{ [6, 3] => [5, 2] }, { [6, 3] => [5, 4] }]
  #       array = pawn.possible_moves(board, [6, 3])
  #       result = array.map(&:moved)
  #       expect(result).to eq(expected)
  #     end

  #     it 'returns moves that leads to capture of the enemy pieces' do
  #       array = pawn.possible_moves(board, [6, 3])
  #       array = array.map(&:removed).reject(&:empty?)

  #       expect(array).to eq([[5, 2], [5, 4]])
  #     end
  #   end

  #   context 'when an en passant move is available' do
  #     prev_state = Board.new(fen_notation: '8/4p3/8/3P4/8/8/8/8')
  #     let(:board) { Board.new(fen_notation: '8/8/8/3Pp3/8/8/8/8', prev_state: prev_state) }
  #     subject(:pawn) { board.piece_at(y: 3, x: 3) }

  #     it 'returns moves containing the en passant' do
  #       array = pawn.possible_moves(board, [3, 3])
  #       result = array.any?(&:en_passant)
  #       expect(result).to be true
  #     end
  #   end

  #   context 'when an en passant move is not available' do
  #     prev_state = Board.new(fen_notation: '8/8/8/8/8/8/8/8')
  #     let(:board) { Board.new(fen_notation: '8/8/8/3Pp3/8/8/8/8', prev_state: prev_state) }
  #     subject(:pawn) { board.piece_at(y: 3, x: 3) }

  #     it 'does not return en passant moves' do
  #       array = pawn.possible_moves(board, [3, 3])
  #       result = array.none?(&:en_passant)
  #       expect(result).to be true
  #     end
  #   end

  #   xcontext 'when another piece is at the en_passant position' do
  #     let(:pawn) { described_class.new('white') }

  #     it 'does not return en passant move' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[3][3] = pawn
  #       board_array[3][4] = double(color: 'black')

  #       prev_board_array = Array.new(8) { Array.new(8) }
  #       prev_board_array[3][3] = pawn
  #       prev_board_array[1][4] = described_class.new('black')

  #       board = double('Board', :board_array => board_array, :prev_board_array => prev_board_array)

  #       array = pawn.possible_moves(board, [3, 3])
  #       result = array.any?(&:en_passant)
  #       expect(result).to be false
  #     end
  #   end

  #   context 'when the pawn is at the 7th rank' do
  #     let(:board) { Board.new(fen_notation: '8/3P4/8/8/8/8/8/8') }
  #     subject(:pawn) { board.piece_at(y: 1, x: 3) }

  #     it 'returns a promotion move' do
  #       array = pawn.possible_moves(board, [1, 3])
  #       result = array.any?(&:promotion)
  #       expect(result).to be true
  #     end
  #   end
  # end
end

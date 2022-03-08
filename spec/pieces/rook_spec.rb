# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative './piece_spec'

describe Rook do
  let(:position) { Position.new(y: 1, x: 1) }
  subject(:rook) { described_class.new('white', position) }
  
  it_behaves_like 'a chess piece', described_class

  describe '#move_sets' do
    it 'returns the correct move_sets' do
      move_set, = rook.move_sets
      expected_increments = [{ y: 1, x: 0 }, { y: -1, x: 0 }, { y: 0, x: 1 },
                             { y: 0, x: -1 }]

      expect(rook.move_sets.size).to eq 1
      expect(move_set.increments).to eq expected_increments
      expect(move_set.repeat).to eq Float::INFINITY
      expect(move_set.blocked_by).to eq :player_piece
      expect(move_set.special_moves).to be_empty
    end
  end

  # describe '#possible_moves' do
  #   subject(:rook) { described_class.new('black') }

  #   context 'when rook is at edge of board' do
  #     it 'returns the correct moves' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[0][0] = rook

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [0, 0])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [0, 0] => [1, 0] }, { [0, 0] => [2, 0] }, { [0, 0] => [3, 0] },
  #                      { [0, 0] => [4, 0] }, { [0, 0] => [5, 0] }, { [0, 0] => [6, 0] },
  #                      { [0, 0] => [7, 0] }, { [0, 0] => [0, 1] }, { [0, 0] => [0, 2] },
  #                      { [0, 0] => [0, 3] }, { [0, 0] => [0, 4] }, { [0, 0] => [0, 7] },
  #                      { [0, 0] => [0, 5] }, { [0, 0] => [0, 6] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when rook is at the middle of the board' do
  #     it 'returns the correct moves' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = rook

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 3] => [0, 3] }, { [4, 3] => [1, 3] }, { [4, 3] => [2, 3] },
  #                      { [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [6, 3] },
  #                      { [4, 3] => [7, 3] }, { [4, 3] => [4, 0] }, { [4, 3] => [4, 1] },
  #                      { [4, 3] => [4, 2] }, { [4, 3] => [4, 4] }, { [4, 3] => [4, 5] },
  #                      { [4, 3] => [4, 6] }, { [4, 3] => [4, 7] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there is an enemy piece blocking the rook path' do
  #     it 'return moves which end at the enemy piece position' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = rook
  #       board_array[2][3] = described_class.new('white')
  #       board_array[4][6] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 3] => [2, 3] }, { [4, 3] => [4, 6] }, { [4, 3] => [4, 5] },
  #                      { [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [6, 3] },
  #                      { [4, 3] => [7, 3] }, { [4, 3] => [4, 0] }, { [4, 3] => [4, 1] },
  #                      { [4, 3] => [4, 2] }, { [4, 3] => [4, 4] }]

  #       expect(result).to eq(expected)
  #     end

  #     it 'return moves that lead to capture of the enemy pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = rook
  #       board_array[2][3] = described_class.new('white')
  #       board_array[4][6] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [4, 3])
  #       result = array.map(&:removed).reject(&:nil?).to_set
  #       expected = Set[[2, 3], [4, 6]]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there is a player piece blocking its path' do
  #     it 'return moves that stop before the player piece' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = rook
  #       board_array[2][3] = described_class.new('black')
  #       board_array[4][6] = described_class.new('black')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 3] => [4, 5] }, { [4, 3] => [4, 2] }, { [4, 3] => [4, 4] },
  #                      { [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [6, 3] },
  #                      { [4, 3] => [7, 3] }, { [4, 3] => [4, 0] }, { [4, 3] => [4, 1] },]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when the rook is blocked on all sides by player pieces' do
  #     it 'returns no moves (empty array)' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = rook
  #       board_array[3][3] = described_class.new('black')
  #       board_array[5][3] = described_class.new('black')
  #       board_array[4][2] = described_class.new('black')
  #       board_array[4][4] = described_class.new('black')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [4, 3])
  #       expect(array).to be_empty
  #     end
  #   end

  #   context 'when rook is blocked on all sides by enemy pieces' do
  #     it 'returns moves that stop at the enemy pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = rook
  #       board_array[3][3] = described_class.new('white')
  #       board_array[5][3] = described_class.new('white')
  #       board_array[4][2] = described_class.new('white')
  #       board_array[4][4] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [4, 2] },
  #                      { [4, 3] => [4, 4] }]

  #       expect(result).to eq(expected)
  #     end

  #     it 'returns moves that leads to capture of the enemy pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = rook
  #       board_array[3][3] = described_class.new('white')
  #       board_array[5][3] = described_class.new('white')
  #       board_array[4][2] = described_class.new('white')
  #       board_array[4][4] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = rook.possible_moves(board, [4, 3])
  #       result = array.map(&:removed).to_set
  #       expected = Set[[3, 3], [5, 3], [4, 2], [4, 4]]

  #       expect(result).to eq(expected)
  #     end
  #   end
  # end
end

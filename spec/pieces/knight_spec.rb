# frozen_string_literal: true

require_relative '../../lib/pieces/knight'
require_relative './piece_spec'

describe Knight do
  let(:position) { Position.new(y: 1, x: 1) }
  subject(:knight) { described_class.new(:white, position) }

  it_behaves_like 'a chess piece', described_class

  describe '#move_sets' do
    it 'returns the correct move_sets' do
      move_set, = knight.move_sets
      expected_increments = [{ y: 2, x: 1 }, { y: 2, x: -1 }, { y: 1, x: 2 },
                             { y: 1, x: -2 }, { y: -2, x: 1 }, { y: -2, x: -1 },
                             { y: -1, x: 2 }, { y: -1, x: -2 }]  

      expect(knight.move_sets.size).to eq 1
      expect(move_set.increments).to eq expected_increments
      expect(move_set.repeat).to eq 1
      expect(move_set.blocked_by).to eq [:same]
      expect(move_set.special_moves).to be_empty
      expect(move_set.promotable).to be false
    end
  end

  # describe '#possible_moves' do
  #   subject(:knight) { described_class.new('white') }

  #   context 'when knight is at starting position' do
  #     it 'returns the correct moves' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[7][2] = knight

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = knight.possible_moves(board, [7, 2])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [7, 2] => [6, 0] }, { [7, 2] => [5, 1] }, { [7, 2] => [5, 3] }, { [7, 2] => [6, 4] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when knight is surrounded by other chess pieces' do
  #     it 'return moves that jump over the chess pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[3] = [nil, nil, 'p', 'p', 'p', nil, nil, nil]
  #       board_array[4] = [nil, nil, 'p', knight, 'p', nil, nil, nil]
  #       board_array[5] = [nil, nil, 'p', 'p', 'p', nil, nil, nil]

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = knight.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 3] => [2, 2] }, { [4, 3] => [3, 1] }, { [4, 3] => [2, 4] }, { [4, 3] => [3, 5] },
  #                      { [4, 3] => [5, 1] }, { [4, 3] => [6, 2] }, { [4, 3] => [6, 4] }, { [4, 3] => [5, 5] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there is an enemy piece where the knight is going' do
  #     it 'returns moves that lead to capture of the enemy piece' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = knight
  #       board_array[2][2] = described_class.new('black')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = knight.possible_moves(board, [4, 3])
  #       result = array.map(&:removed).reject(&:nil?)
  #       expected = [[2, 2]]
  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there is player piece where knight is going' do
  #     it 'does not return moves where the player piece is' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = knight
  #       board_array[2][2] = described_class.new('white')
  #       board_array[3][5] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = knight.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set

  #       expected = Set[{ [4, 3] => [3, 1] }, { [4, 3] => [2, 4] }, { [4, 3] => [5, 1] }, { [4, 3] => [6, 2] },
  #                      { [4, 3] => [6, 4] }, { [4, 3] => [5, 5] }]

  #       expect(result).to eq(expected)
  #     end
  #   end
  # end
end

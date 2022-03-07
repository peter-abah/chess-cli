# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'

describe Bishop do
  subject(:bishop) { described_class.new('white') }

  describe '#initialize' do
    let(:color) { 'black' }
    subject(:bishop) { described_class.new(color) }

    it 'creates a new object with @color as its first argument' do
      result = bishop.instance_variable_get(:@color)
      expect(result).to eq(color)
    end

    it 'has a @has_moved attribute with value of false' do
      result = bishop.instance_variable_get(:@has_moved)
      expect(result).to be false
    end
  end

  describe '#move_sets' do
    it 'returns the correct move_sets' do
      move_set, = bishop.move_sets
      expected_increments = [{ y: 1, x: 1 }, { y: -1, x: 1 }, { y: -1, x: -1 },
                             { y: 1, x: -1 }]

      expect(bishop.move_sets.size).to eq 1
      expect(move_set.increments).to eq expected_increments
      expect(move_set.repeat).to eq Float::INFINITY
      expect(move_set.blocked_by).to eq :player_piece
      expect(move_set.special_moves).to be_empty
    end
  end

  # describe '#possible_moves' do
  #   subject(:bishop) { described_class.new('black') }

  #   context 'when bishop is at edge of board' do
  #     it 'returns the correct moves' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[7][0] = bishop

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [7, 0])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [7, 0] => [6, 1] }, { [7, 0] => [5, 2] }, { [7, 0] => [4, 3] },
  #                      { [7, 0] => [3, 4] }, { [7, 0] => [2, 5] }, { [7, 0] => [1, 6] },
  #                      { [7, 0] => [0, 7] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when bishop is at middle of board' do
  #     it 'returns the correct moves' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[3][4] = bishop

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [3, 4])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [3, 4] => [7, 0] }, { [3, 4] => [6, 1] }, { [3, 4] => [5, 2] },
  #                      { [3, 4] => [4, 3] }, { [3, 4] => [2, 5] }, { [3, 4] => [1, 6] },
  #                      { [3, 4] => [0, 7] }, { [3, 4] => [0, 1] }, { [3, 4] => [1, 2] },
  #                      { [3, 4] => [2, 3] }, { [3, 4] => [4, 5] }, { [3, 4] => [5, 6] },
  #                      { [3, 4] => [6, 7] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there is an ememy piece blocking the bishop path' do
  #     it 'returns moves that stop at the enemy piece position' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = bishop
  #       board_array[2][1] = described_class.new('white')
  #       board_array[1][6] = described_class.new('white')
  #       board_array[6][5] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 3] => [2, 1] }, { [4, 3] => [3, 2] }, { [4, 3] => [5, 4] },
  #                      { [4, 3] => [6, 5] }, { [4, 3] => [1, 6] }, { [4, 3] => [2, 5] },
  #                      { [4, 3] => [3, 4] }, { [4, 3] => [5, 2] }, { [4, 3] => [6, 1] },
  #                      { [4, 3] => [7, 0] }]

  #       expect(result).to eq(expected)
  #     end

  #     it 'return moves that lead to capture of the enemy pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = bishop
  #       board_array[2][1] = described_class.new('white')
  #       board_array[1][6] = described_class.new('white')
  #       board_array[6][5] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)
  #       array = bishop.possible_moves(board, [4, 3])
  #       result = array.map(&:removed).reject(&:nil?).to_set
  #       expected = Set[[2, 1], [1, 6], [6, 5]]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there is a player piece blocking its path' do
  #     it 'return moves that stop before the player piece' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[2][2] = bishop
  #       board_array[1][1] = described_class.new('black')
  #       board_array[0][4] = described_class.new('black')
  #       board_array[5][5] = described_class.new('black')
  #       board_array[4][0] = described_class.new('black')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [2, 2])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [2, 2] => [1, 3] }, { [2, 2] => [3, 1] }, { [2, 2] => [3, 3] },
  #                      { [2, 2] => [4, 4] }]

  #       expect(result).to eq(expected)
  #     end

  #     it 'does not capture any piece' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[2][2] = bishop
  #       board_array[1][1] = described_class.new('black')
  #       board_array[0][4] = described_class.new('black')
  #       board_array[5][5] = described_class.new('black')
  #       board_array[4][0] = described_class.new('black')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [2, 2])
  #       result = array.map(&:removed).reject(&:nil?)

  #       expect(result).to be_empty
  #     end
  #   end

  #   context 'when the bishop is blocked on all sides by player pieces' do
  #     it 'returns no moves (empty array)' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = bishop
  #       board_array[3][2] = described_class.new('black')
  #       board_array[5][4] = described_class.new('black')
  #       board_array[5][2] = described_class.new('black')
  #       board_array[3][4] = described_class.new('black')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [4, 3])
  #       expect(array).to be_empty
  #     end
  #   end

  #   context 'when it is blocked on all sides by enemy pieces' do
  #     it 'return moves that stop at the ememy pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = bishop
  #       board_array[3][2] = described_class.new('white')
  #       board_array[5][4] = described_class.new('white')
  #       board_array[5][2] = described_class.new('white')
  #       board_array[3][4] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [4, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 3] => [3, 2] }, { [4, 3] => [3, 4] }, { [4, 3] => [5, 2] },
  #                      { [4, 3] => [5, 4] }]

  #       expect(result).to eq(expected)
  #     end

  #     it 'returns moves that leads to capture of the enemy piece' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][3] = bishop
  #       board_array[3][2] = described_class.new('white')
  #       board_array[5][4] = described_class.new('white')
  #       board_array[5][2] = described_class.new('white')
  #       board_array[3][4] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = bishop.possible_moves(board, [4, 3])
  #       result = array.map(&:removed).to_set
  #       expected = Set[[3, 2], [5, 4], [5, 2], [3, 4]]

  #       expect(result).to eq(expected)
  #     end
  #   end
  # end
end

# frozen_string_literal: true

require_relative '../../lib/pieces/queen'

describe Queen do
  subject(:queen) { described_class.new('white') }

  describe '#initialize' do
    context 'when called with one argument' do
      let(:color) { 'white' }
      subject(:queen) { described_class.new(color) }

      it 'creates a new object with @color as its 1st argument' do
        result = queen.instance_variable_get(:@color)
        expect(result).to eq(color)
      end

      it 'has a @has_moved attribute with value of false' do
        result = queen.instance_variable_get(:@has_moved)
        expect(result).to be false
      end
    end
  end

  describe '#move_sets' do
    it 'returns the correct move_sets' do
      move_set, = queen.move_sets
      expected_directions = [{ y: 1, x: 1 }, { y: -1, x: 1 }, { y: -1, x: -1 },
                             { y: 1, x: -1 }, { y: 1, x: 0 }, { y: -1, x: 0 },
                             { y: 0, x: 1 }, { y: 0, x: -1 }]

      expect(queen.move_sets.size).to eq 1
      expect(move_set.directions).to eq expected_directions
      expect(move_set.repeat).to eq Float::INFINITY
      expect(move_set.blocked_by).to eq :player_piece
      expect(move_set.special_moves).to be_empty
    end
  end

  # describe "#possible_moves" do
  #   subject(:queen) { described_class.new('white') }

  #   context 'when queen is at edge of board' do
  #     it 'returns the correct moves' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[0][0] = queen

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = queen.possible_moves(board, [0, 0])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [0, 0] => [1, 0] }, { [0, 0] => [2, 0] }, { [0, 0] => [3, 0] },
  #                      { [0, 0] => [4, 0] }, { [0, 0] => [5, 0] }, { [0, 0] => [6, 0] },
  #                      { [0, 0] => [7, 0] }, { [0, 0] => [0, 1] }, { [0, 0] => [0, 2] },
  #                      { [0, 0] => [0, 3] }, { [0, 0] => [0, 4] }, { [0, 0] => [0, 5] },
  #                      { [0, 0] => [0, 6] }, { [0, 0] => [0, 7] }, { [0, 0] => [1, 1] },
  #                      { [0, 0] => [2, 2] }, { [0, 0] => [3, 3] }, { [0, 0] => [4, 4] },
  #                      { [0, 0] => [5, 5] }, { [0, 0] => [6, 6] }, { [0, 0] => [7, 7] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when queen is at middle of board' do
  #     it 'returns the correct moves' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][4] = queen

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = queen.possible_moves(board, [4, 4])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 4] => [0, 4] }, { [4, 4] => [1, 4] }, { [4, 4] => [2, 4] },
  #                      { [4, 4] => [3, 4] }, { [4, 4] => [5, 4] }, { [4, 4] => [6, 4] },
  #                      { [4, 4] => [7, 4] }, { [4, 4] => [4, 0] }, { [4, 4] => [4, 1] },
  #                      { [4, 4] => [4, 2] }, { [4, 4] => [4, 3] }, { [4, 4] => [4, 5] },
  #                      { [4, 4] => [4, 6] }, { [4, 4] => [4, 7] }, { [4, 4] => [0, 0] },
  #                      { [4, 4] => [1, 1] }, { [4, 4] => [2, 2] }, { [4, 4] => [3, 3] },
  #                      { [4, 4] => [5, 5] }, { [4, 4] => [6, 6] }, { [4, 4] => [7, 7] },
  #                      { [4, 4] => [1, 7] }, { [4, 4] => [2, 6] }, { [4, 4] => [3, 5] },
  #                      { [4, 4] => [5, 3] }, { [4, 4] => [6, 2] }, { [4, 4] => [7, 1] }]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there are enemy pieces blocking the queen' do
  #     subject(:queen) { described_class.new('black') }

  #     it 'returns moves that stop at the enemy pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][4] = queen
  #       board_array[2][2] = described_class.new('white')
  #       board_array[1][7] = described_class.new('white')
  #       board_array[1][4] = described_class.new('white')
  #       board_array[6][6] = described_class.new('white')
  #       board_array[4][6] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = queen.possible_moves(board, [4, 4])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 4] => [1, 4] }, { [4, 4] => [2, 4] }, { [4, 4] => [4, 6] },
  #                      { [4, 4] => [3, 4] }, { [4, 4] => [5, 4] }, { [4, 4] => [6, 4] },
  #                      { [4, 4] => [7, 4] }, { [4, 4] => [4, 0] }, { [4, 4] => [4, 1] },
  #                      { [4, 4] => [4, 2] }, { [4, 4] => [4, 3] }, { [4, 4] => [4, 5] },
  #                      { [4, 4] => [2, 2] }, { [4, 4] => [3, 3] }, { [4, 4] => [6, 6] },
  #                      { [4, 4] => [1, 7] }, { [4, 4] => [2, 6] }, { [4, 4] => [3, 5] },
  #                      { [4, 4] => [5, 3] }, { [4, 4] => [6, 2] }, { [4, 4] => [7, 1] },
  #                      { [4, 4] => [5, 5] }]

  #       expect(result).to eq(expected)
  #     end

  #     it 'returns moves that capture the enemy pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][4] = queen
  #       board_array[2][2] = described_class.new('white')
  #       board_array[1][7] = described_class.new('white')
  #       board_array[1][4] = described_class.new('white')
  #       board_array[6][6] = described_class.new('white')
  #       board_array[4][6] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = queen.possible_moves(board, [4, 4])
  #       result = array.map(&:removed).reject(&:nil?).to_set
  #       expected = Set[[2, 2], [1, 7], [1, 4], [6, 6], [4, 6]]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there are player pieces blocking the queen' do
  #     it 'returns moves that stop before the player pieces' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][4] = queen
  #       board_array[2][2] = described_class.new('white')
  #       board_array[1][7] = described_class.new('white')
  #       board_array[1][4] = described_class.new('white')
  #       board_array[6][6] = described_class.new('white')
  #       board_array[4][6] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = queen.possible_moves(board, [4, 4])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [4, 4] => [3, 4] }, { [4, 4] => [5, 4] }, { [4, 4] => [6, 4] },
  #                      { [4, 4] => [7, 4] }, { [4, 4] => [4, 0] }, { [4, 4] => [4, 1] },
  #                      { [4, 4] => [4, 2] }, { [4, 4] => [4, 3] }, { [4, 4] => [4, 5] },
  #                      { [4, 4] => [2, 6] }, { [4, 4] => [3, 5] }, { [4, 4] => [3, 3] },
  #                      { [4, 4] => [5, 3] }, { [4, 4] => [6, 2] }, { [4, 4] => [7, 1] },
  #                      { [4, 4] => [2, 4] }, { [4, 4] => [5, 5] }]

  #       expect(result).to eq(expected)
  #     end

  #     it 'does not capture any piece' do
  #       board_array = Array.new(8) { Array.new(8) }
  #       board_array[4][4] = queen
  #       board_array[2][2] = described_class.new('white')
  #       board_array[1][7] = described_class.new('white')
  #       board_array[1][4] = described_class.new('white')
  #       board_array[6][6] = described_class.new('white')
  #       board_array[4][6] = described_class.new('white')

  #       board = double(board_array: board_array, prev_board_array: nil)

  #       array = queen.possible_moves(board, [4, 4])
  #       result = array.map(&:removed).reject(&:nil?)
        
  #       expect(result).to be_empty
  #     end
  #   end
  # end
end

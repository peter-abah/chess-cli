# frozen_string_literal: true

require_relative '../lib/pieces/rook'

describe Rook do
  describe '#initialize' do
    context 'when called with one argument' do
      let(:color) { 'black' }
      subject(:rook) { described_class.new(color) }

      it 'creates a new object with @color as its first argument' do
        result = rook.instance_variable_get(:@color)
        expect(result).to eq(color)
      end
    end
  end

  describe '#possible_moves' do
    subject(:rook) { described_class.new('black') }

    context 'when rook is at edge of board' do
      it 'returns the correct moves' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[0][0] = rook

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [0, 0])
        result = array.map(&:moved).to_set
        expected = Set[{ [0, 0] => [1, 0] }, { [0, 0] => [2, 0] }, { [0, 0] => [3, 0] },
                       { [0, 0] => [4, 0] }, { [0, 0] => [5, 0] }, { [0, 0] => [6, 0] },
                       { [0, 0] => [7, 0] }, { [0, 0] => [0, 1] }, { [0, 0] => [0, 2] },
                       { [0, 0] => [0, 3] }, { [0, 0] => [0, 4] }, { [0, 0] => [0, 7] },
                       { [0, 0] => [0, 5] }, { [0, 0] => [0, 6] }]

        expect(result).to eq(expected)
      end
    end

    context 'when rook is at the middle of the board' do
      it 'returns the correct moves' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[4][3] = rook

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [4, 3])
        result = array.map(&:moved).to_set
        expected = Set[{ [4, 3] => [0, 3] }, { [4, 3] => [1, 3] }, { [4, 3] => [2, 3] },
                       { [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [6, 3] },
                       { [4, 3] => [7, 3] }, { [4, 3] => [4, 0] }, { [4, 3] => [4, 1] },
                       { [4, 3] => [4, 2] }, { [4, 3] => [4, 4] }, { [4, 3] => [4, 5] },
                       { [4, 3] => [4, 6] }, { [4, 3] => [4, 7] }]

        expect(result).to eq(expected)
      end
    end

    context 'when there is an enemy piece blocking the rook path' do
      it 'return moves which end at the enemy piece position' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[4][3] = rook
        board_array[2][3] = described_class.new('white')
        board_array[4][6] = described_class.new('white')

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [4, 3])
        result = array.map(&:moved).to_set
        expected = Set[{ [4, 3] => [2, 3] }, { [4, 3] => [4, 6] }, { [4, 3] => [4, 5] },
                       { [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [6, 3] },
                       { [4, 3] => [7, 3] }, { [4, 3] => [4, 0] }, { [4, 3] => [4, 1] },
                       { [4, 3] => [4, 2] }, { [4, 3] => [4, 4] }]

        expect(result).to eq(expected)
      end

      it 'return moves that lead to capture of the enemy pieces' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[4][3] = rook
        board_array[2][3] = described_class.new('white')
        board_array[4][6] = described_class.new('white')

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [4, 3])
        result = array.map(&:removed).reject(&:nil?).to_set
        expected = Set[[2, 3], [4, 6]]

        expect(result).to eq(expected)
      end
    end

    context 'when there is a player piece blocking its path' do
      it 'return moves that stop before the player piece' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[4][3] = rook
        board_array[2][3] = described_class.new('black')
        board_array[4][6] = described_class.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [4, 3])
        result = array.map(&:moved).to_set
        expected = Set[{ [4, 3] => [4, 5] }, { [4, 3] => [4, 2] }, { [4, 3] => [4, 4] },
                       { [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [6, 3] },
                       { [4, 3] => [7, 3] }, { [4, 3] => [4, 0] }, { [4, 3] => [4, 1] },]

        expect(result).to eq(expected)
      end
    end

    context 'when the rook is blocked on all sides by player pieces' do
      it 'returns no moves (empty array)' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[4][3] = rook
        board_array[3][3] = described_class.new('black')
        board_array[5][3] = described_class.new('black')
        board_array[4][2] = described_class.new('black')
        board_array[4][5] = described_class.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [4, 3])
        expect(array).to be_empty
      end
    end

    context 'when rook is blocked on all sides by enemy pieces' do
      it 'returns moves that stop at the enemy pieces' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[4][3] = rook
        board_array[3][3] = described_class.new('black')
        board_array[5][3] = described_class.new('black')
        board_array[4][2] = described_class.new('black')
        board_array[4][5] = described_class.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [4, 3])
        result = array.map(&:moved).to_set
        expected = Set[{ [4, 3] => [3, 3] }, { [4, 3] => [5, 3] }, { [4, 3] => [4, 2] },
                       { [4, 3] => [4, 5] }]

        expect(result).to eq(expected)
      end

      it 'returns moves that leads to capture of the enemy pieces' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[4][3] = rook
        board_array[3][3] = described_class.new('black')
        board_array[5][3] = described_class.new('black')
        board_array[4][2] = described_class.new('black')
        board_array[4][5] = described_class.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = rook.possible_moves(board, [4, 3])
        result = array.map(:removed).to_set
        expected = Set[[3, 3], [5, 3], [4, 2], [4, 4]]

        expect(result).to eq(expected)
      end
    end
  end
end

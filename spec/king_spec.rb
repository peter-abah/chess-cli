# frozen_string_literal: true

require_relative '../lib/pieces/king'
require_relative '../lib/pieces/rook'

describe King do
  describe '#initialize' do
    context 'when called with one argument' do
      let(:color) { 'white' }
      subject(:king) { described_class.new(color) }

      it 'creates a new object with @color as the first argument' do
        result = king.instance_variable_get(:@color)
        expect(result).to eq(color)
      end

      it 'creates an object with the correct directions' do
        directions = [[-1, -1], [1, 1], [1, -1], [-1, 1], [0, -1], [0, 1],
                      [-1, 0], [1, 0]]
        result = king.instance_variable_get(:@directions)
        expect(result).to eq(directions)
      end

      it 'creates an object with @has_moved as false' do
        has_moved = king.instance_variable_get(:@has_moved)
        expect(has_moved).to be_false
      end
    end
  end

  describe '#possible_moves' do
    subject(:king) { described_class.new('black') }

    context 'when king is at edge of board' do
      it 'returns the correct moves' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[0][7] = king

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [0, 7])
        result = array.map(&:moved).to_set
        expected = Set[{ [0, 7] => [0, 6] }, { [0, 7] => [1, 7] }, { [0, 7] => [1, 6] }]

        expect(result).to eq(expected)
      end
    end

    context 'when the king is at the center of the board' do
      it 'returns the correct moves' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = king

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [3, 3])
        result = array.map(&:moved).to_set
        expected = Set[{ [3, 3] => [3, 2] }, { [3, 3] => [3, 4] }, { [3, 3] => [2, 3] },
                       { [3, 3] => [4, 3] }, { [3, 3] => [2, 2] }, { [3, 3] => [4, 4] },
                       { [3, 3] => [2, 4] }, { [3, 3] => [4, 2] }]

        expect(result).to eq(expected)
      end
    end

    context 'when there are enemy pieces blocking its path' do
      it 'returns moves that include enemy pieces' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = king
        board_array[2][2] = described_class.new('white')
        board_array[3][2] = described_class.new('white')
        board_array[3][4] = described_class.new('white')

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [3, 3])
        result = array.map(&:moved).to_set
        expected = Set[{ [3, 3] => [3, 2] }, { [3, 3] => [3, 4] }, { [3, 3] => [2, 3] },
                       { [3, 3] => [4, 3] }, { [3, 3] => [2, 2] }, { [3, 3] => [4, 4] },
                       { [3, 3] => [2, 4] }, { [3, 3] => [4, 2] }]

        expect(result).to eq(expected)
      end

      it 'returns moves that capture the enemy pieces' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = king
        board_array[2][2] = described_class.new('white')
        board_array[3][2] = described_class.new('white')
        board_array[3][4] = described_class.new('white')

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [3, 3])
        result = array.map(&:removed).reject(:nil?).to_set
        expected = Set[[2, 2], [3, 2], [3, 4]]

        expect(result).to eq(expected)
      end
    end

    context 'when there are player pieces blocking the path' do
      it 'returns moves that does not include the player pieces positions' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = king
        board_array[2][2] = described_class.new('black')
        board_array[3][2] = described_class.new('black')
        board_array[3][4] = described_class.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [3, 3])
        result = array.map(&:moved).to_set
        expected = Set[{ [3, 3] => [4, 3] }, { [3, 3] => [4, 4] }, { [3, 3] => [2, 3] },
                       { [3, 3] => [2, 4] }, { [3, 3] => [4, 2] }]

        expect(result).to eq(expected)
      end

      it 'returns moves that do not capture any player piece' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = king
        board_array[2][2] = described_class.new('black')
        board_array[3][2] = described_class.new('black')
        board_array[3][4] = described_class.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [3, 3])
        result = array.map(&:removed).reject(&:nil?)
        expect(result).to be_empty
      end
    end

    context 'when castling is available on kingside' do
      it 'returns moves that include a castling move' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[0][4] = king
        board_array[0][7] = Rook.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [0, 4])
        result = array.map(&:moved).to_set
        expected = Set[{ [0, 4] => [0, 6], [0, 7] => [0, 5] }, { [0, 4] => [0, 5] },
                       { [0, 4] => [0, 3] }, { [0, 4] => [1, 4] }, { [0, 4] => [1, 3] },
                       { [0, 4] => [1, 5] }]

        expect(result).to eq(expected)
      end
    end

    context 'when castling is available on queenside' do
      it 'returns moves that include a castling move' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[0][4] = king
        board_array[0][0] = Rook.new('black')

        board = double(board_array: board_array, prev_board_array: nil)

        array = king.possible_moves(board, [0, 4])
        result = array.map(&:moved).to_set
        expected = Set[{ [0, 4] => [0, 2], [0, 0] => [0, 3] }, { [0, 4] => [0, 5] },
                       { [0, 4] => [0, 3] }, { [0, 4] => [1, 4] }, { [0, 4] => [1, 3] },
                       { [0, 4] => [1, 5] }]

        expect(result).to eq(expected)
      end
    end
  end
end

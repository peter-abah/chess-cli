# frozen_string_literal: true

require_relative '../lib/pieces/pawn'

describe Pawn do
  describe '#initialize' do
    context 'when called with one argument' do
      let(:color) { 'white' }
      subject(:pawn) { described_class.new(color) }
    end
  end

  describe '#possible_moves' do
    context 'when called with a board at default position' do
      board_array = Array.new(8) { Array.new(8) }
      board_array[6] = Array.new(8) { Pawn.new('white') }

      let(:board) { double('Board', :board_array => board_array, :prev_board_array => nil) }
      let(:pawn) { board_array[6][3] }

      it 'returns an array of Move objects' do
        array = pawn.possible_moves(board, [6, 3])
        result = array.all? { |e| e.is_a? Move }
        expect(result).to eq(true)
      end

      it 'returns the correct moves' do
        expected = [{ [6, 3] => [5, 3] }, { [6, 3] => [4, 3] }]

        array = pawn.possible_moves(board, [6, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end
    end

    context 'when called with the pawn at third rank' do
      subject(:pawn) { described_class.new('white') }

      it 'returns the correct moves' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[5][3] = pawn

        board = double('Board', :board_array => board_array, :prev_board_array => nil)
        expected = [{ [5, 3] => [4, 3] }]

        array = pawn.possible_moves(board, [5, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end
    end

    context 'when there is a chess piece blocking it' do
      let(:pawn) { described_class.new('white') }

      it 'returns an empty array' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[6][3] = pawn
        board_array[5][3] = described_class.new('white')

        board = double('Board', :board_array => board_array, :prev_board_array => nil)
        array = pawn.possible_moves(board, [6, 3])
        expect(array).to be_empty
      end
    end

    context 'when there is an enemy piece diagonal to it' do
      let(:pawn) { described_class.new('white') }

      it 'returns the correct move' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[6][3] = pawn
        board_array[5][4] = described_class.new('black')

        board = double('Board', :board_array => board_array, :prev_board_array => nil)

        expected = [{ [6, 3] => [5, 3] }, { [6, 3] => [4, 3] }, { [6, 3] => [5, 4] }]

        array = pawn.possible_moves(board, [6, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end

      it 'returns a move that leads to capture of piece' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[6][3] = pawn
        board_array[5][4] = described_class.new('black')

        board = double('Board', :board_array => board_array, :prev_board_array => nil)

        array = pawn.possible_moves(board, [6, 3])
        result = array.any? { |e| e.removed == [5, 4] }
        expect(result).to be true
      end
    end

    context 'when there is a piece blocking it but there are two empty pieces in its front diagonal' do
      let(:pawn) { described_class.new('white') }

      it 'returns the correct move' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[6][3] = pawn
        board_array[5][4] = described_class.new('black')
        board_array[5][3] = described_class.new('black')
        board_array[5][2] = described_class.new('black')

        board = double('Board', :board_array => board_array, :prev_board_array => nil)

        expected = [{ [6, 3] => [5, 2] }, { [6, 3] => [5, 4] }]

        array = pawn.possible_moves(board, [6, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end

      it 'returns moves that leads to capture of the enemy pieces' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[6][3] = pawn
        board_array[5][4] = described_class.new('black')
        board_array[5][3] = described_class.new('black')
        board_array[5][2] = described_class.new('black')

        board = double('Board', :board_array => board_array, :prev_board_array => nil)

        array = pawn.possible_moves(board, [6, 3])
        array = array.map(&:removed).reject(&:empty?)

        expect(array).to eq([[5, 2], [5, 4]])
      end
    end

    context 'when an en passant move is available' do
      let(:pawn) { described_class.new('white') }

      it 'returns moves containing the en passant' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = pawn
        board_array[3][4] = described_class.new('black')

        prev_board_array = Array.new(8) { Array.new(8) }
        prev_board_array[3][3] = pawn
        prev_board_array[1][4] = described_class.new('black')

        board = double('Board', :board_array => board_array, :prev_board_array => prev_board_array)

        array = pawn.possible_moves(board, [3, 3])
        result = array.any?(&:en_passant)
        expect(result).to be true
      end
    end

    context 'when an en passant move is not available' do
      let(:pawn) { described_class.new('white') }

      it 'does not return en passant moves' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = pawn
        board_array[3][4] = described_class.new('black')

        prev_board_array = Array.new(8) { Array.new(8) }

        board = double('Board', :board_array => board_array, :prev_board_array => prev_board_array)

        array = pawn.possible_moves(board, [3, 3])
        result = array.none?(&:en_passant)
        expect(result).to be true
      end
    end

    context 'when another piece is at the en_passant position' do
      let(:pawn) { described_class.new('white') }

      it 'does not return en passant move' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[3][3] = pawn
        board_array[3][4] = double(color: 'black')

        prev_board_array = Array.new(8) { Array.new(8) }
        prev_board_array[3][3] = pawn
        prev_board_array[1][4] = described_class.new('black')

        board = double('Board', :board_array => board_array, :prev_board_array => prev_board_array)

        array = pawn.possible_moves(board, [3, 3])
        result = array.any?(&:en_passant)
        expect(result).to be false
      end
    end

    context 'when the pawn is at the 7th rank' do
      let(:pawn) { described_class.new('white') }

      it 'returns a promotion move' do
        board_array = Array.new(8) { Array.new(8) }
        board_array[1][3] = pawn

        board = double('Board', :board_array => board_array, :prev_board_array => nil)

        array = pawn.possible_moves(board, [1, 3])
        result = array.any?(&:promotion)
        expect(result).to be true
      end
    end
  end
end

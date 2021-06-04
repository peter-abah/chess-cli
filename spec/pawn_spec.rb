# frozen_string_literal: true

describe Pawn do
  describe '#initialize' do
    context 'when called with one argument' do
      let(:color) { 'white' }
      # let(:pos) { [6, 3] }
      subject(:pawn) { described_class.new(color) }

      it 'has an attribute @color' do
        result = pawn.instance_variable_get(:@color)
        expect(result).to eq(color)
      end

      # it 'has an attribute @pos' do
      #   result = pawn.instance_variable_get(:@pos)
      #   expect(result).to eq(pos)
      # end
    end
  end

  describe '#possible_moves' do

    context 'when called with a board at default position' do
      board_array = Array.new(8) { Array.new(8) }
      board_array[6] = Array.new(8) { |i| Pawn.new('white') }

      let(:board) { double('Board', :board_array => board, prev_board_array => nil) }
      let(:pawn) { board_array[6, 3] }

      xit 'returns an array of Move objects' do
        array = pawn.possible_moves(board, [6, 3])
        result = array.all? { |e| e.is_a? Move  }
        expect(result).to eq(true)
      end

      xit 'returns the correct moves' do
        expected = [[[6, 3], [5, 3]], [[6, 3], [4, 3]]]

        array = pawn.possible_moves(board, [6, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end
    end

    context 'when called with the pawn at third rank' do
      let(:pawn) { described_class.new('white') }

      board_array = Array.new(8) { Array.new(8) }
      board_array[5][3] = pawn

      let(:board) { double('Board', :board_array => board, prev_board_array => nil) }

      xit 'returns the correct moves' do
        expected = [[[5, 3], [4, 3]]]

        array = pawn.possible_moves(board, [5, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end
    end

    context 'when there is a chess piece blocking it' do
      let(:pawn) { described_class.new('white') }

      board_array = Array.new(8) { Array.new(8) }
      board_array[6, 3] = pawn
      board_array[5, 3] = described_class.new('white')

      let(:board) { double('Board', :board_array => board, prev_board_array => nil) }

      xit 'returns an empty array' do
        array = pawn.possible_moves(board, [6, 3])
        expect(array).to be_empty
      end
    end

    context 'when there is an enemy piece diagonal to it' do
      let(:pawn) { described_class.new('white') }

      board_array = Array.new(8) { Array.new(8) }
      board_array[6, 3] = pawn
      board_array[5, 4] = described_class.new('black')

      let(:board) { double('Board', :board_array => board, prev_board_array => nil) }

      xit 'returns the correct move' do
        expected = [[[6, 3], [5, 3]], [[6, 3], [4, 3]], [[6, 3], [5, 4]]]

        array = pawn.possible_moves(board, [6, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end

      xit 'returns a move that leads to capture of piece' do
        array = pawn.possibles_moves(board, [6, 3])
        result = array.any? { |e| e.removed == [5, 4] }
        expect(result).to be true
      end
    end

    context 'when there is a piece blocking it but there are two empty pieces in its front diagonal' do
      let(:pawn) { described_class.new('white') }

      board_array = Array.new(8) { Array.new(8) }
      board_array[6, 3] = pawn
      board_array[5, 4] = described_class.new('black')
      board_array[5, 3] = described_class.new('black')
      board_array[5, 2] = described_class.new('black')

      let(:board) { double('Board', :board_array => board, prev_board_array => nil) }
      
      xit 'returns the correct move' do
        expected = [[[6, 3], [5, 2]], [[6, 3], [5, 4]]]

        array = pawn.possible_moves(board, [6, 3])
        result = array.map(&:moved)
        expect(result).to eq(expected)
      end

      xit 'returns moves that leads to capture of the enemy pieces' do
        array = pawn.possible_moves(board, [6, 3])
        array = array.map(&:removed).select { |e| !e.empty? }

        expect(array).to eq([[5, 2], [5, 4]])
      end
    end
  end
end
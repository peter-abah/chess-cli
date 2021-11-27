# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#initilize' do
    context 'when called with no argument' do
      subject(:board) { described_class.new }

      it 'creates a new object with @board_array that is a array of 8 arrays' do
        board_array = board.instance_variable_get(:@board_array)
        result = board_array.all? { |e| e.is_a? Array }
        expect(result).not_to be_a Array
      end

      it '@board_array element at index 1 is an array that consists of black pawns' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[1]
        result = row.all? { |p| p.is_a?(Pawn) && p.color == 'black' }
        expect(result).to be true
      end

      it '@board_array element at index 6 is an array of white pawns' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[6]
        result = row.all? { |p| p.is_a?(Pawn) && p.color == 'white' }
        expect(result).to be true
      end

      it 'first and last element at the first row of @board_array is a black rook' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[0]
        result = row[0].is_a?(Rook) && row[0].color == 'black' &&
                 row[7].is_a?(Rook) && row[7].color == 'black'
        expect(result).to be true
      end

      it 'first and last element at the last row of @board_array is a white rook' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[7]
        result = row[0].is_a?(Rook) && row[0].color == 'white' &&
                 row[7].is_a?(Rook) && row[7].color == 'white'
        expect(result).to be true
      end

      it '2nd and 7th elements of the 1st row of @board_array is a black knight' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[0]
        result = row[1].is_a?(Knight) && row[1].color == 'black' &&
                 row[6].is_a?(Knight) && row[6].color == 'black'
        expect(result).to be true
      end

      it '2nd and 7th elements of the last row of @board_array is a white knight' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[7]
        result = row[1].is_a?(Knight) && row[1].color == 'white' &&
                 row[6].is_a?(Knight) && row[6].color == 'white'
        expect(result).to be true
      end

      it '3rd and 6th elements of the 1st row of @board_array is black bishop' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[0]
        result = row[2].is_a?(Bishop) && row[2].color == 'black' &&
                 row[5].is_a?(Bishop) && row[5].color == 'black'
        expect(result).to be true
      end

      it '3rd and 6th elements of the last row of @board_array is white bishop' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[7]
        result = row[2].is_a?(Bishop) && row[2].color == 'white' &&
                 row[5].is_a?(Bishop) && row[5].color == 'white'
        expect(result).to be true
      end

      it '4th element is black queen and 5th element is a black king in the 1st row of @board_array' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[0]
        result = row[3].is_a?(Queen) && row[3].color == 'black' &&
                 row[4].is_a?(King) && row[4].color == 'black'
        expect(result).to be true
      end

      it '4th element is white queen and 5th element is a white king in the last row of @board_array' do
        board_array = board.instance_variable_get(:@board_array)
        row = board_array[7]
        result = row[3].is_a?(Queen) && row[3].color == 'white' &&
                 row[4].is_a?(King) && row[4].color == 'white'
        expect(result).to be true
      end

      it 'the rest rows are empty arrays' do
        board_array = board.instance_variable_get(:@board_array)
        result = board_array[2..5].all? do |e|
          e.reject(&:nil?).empty?
        end

        expect(result).to be true
      end

      it 'saves pieces positions in @pieces' do
        # TO DO
      end
    end

    context 'when called with two arguments' do
      let(:board_array) { 'first' }
      let(:prev_board_array) { 'second' }
      subject(:board) { described_class.new(board_array, prev_board_array) }

      xit 'creates a new object with @board_array as first argument' do
        result = board.instance_variable_get(:@board_array)
        expect(result).to eq(board_array)
      end

      xit 'creates a new object with @prev_board_array as 2nd argument' do
        result = board.instance_variable_get(:@prev_board_array)
        expect(result).to eq(prev_board_array)
      end
    end
  end

  describe '#update' do
    subject(:board) { described_class.new }

    context 'when called with a move to move a pawn' do
      it 'returns a new board updated with the move' do
        move = double(moved: { [1, 3] => [3, 3] }, removed: nil, promotion: false)

        new_board_array = board.update(move).instance_variable_get(:@board_array)
        result = new_board_array[3][3]

        expect(result).to be_a Pawn
      end

      it 'returns a new board with @prev_board_array as the board board_array' do
        board_array = board.instance_variable_get(:@board_array)
        move = double(moved: { [1, 3] => [3, 3] }, removed: nil, promotion: false)

        prev_board_array = board.update(move).instance_variable_get(:@prev_board_array)
        expect(prev_board_array).to eq(board_array)
      end
    end

    context 'when called with a move to move a knight' do
      it 'returns a new board updated with the move' do
        move = double(moved: { [0, 1] => [2, 0] }, removed: nil, promotion: false)

        new_board_array = board.update(move).instance_variable_get(:@board_array)
        result = new_board_array[2][0]
        expect(result).to be_a Knight
      end
    end

    context 'when called with a move to remove a piece' do
      it 'returns a new board updated with the board' do
        move = double(moved: { [0, 1] => [2, 0] }, removed: [7, 5], promotion: false)

        new_board_array = board.update(move).instance_variable_get(:@board_array)
        result = new_board_array[7][5]
        expect(result).to be_nil
      end
    end

    context 'when called with a move that promotes a pawn' do
      it 'returns a new board with the piece being promoted' do
        move = double(moved: { [1, 1] => [2, 1] }, removed: nil, promotion: Queen)

        new_board_array = board.update(move).instance_variable_get(:@board_array)
        result = new_board_array[2][1]
        expect(result).to be_a Queen
      end
    end
  end
end

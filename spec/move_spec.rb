# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/move'

describe Move do
  let(:position) { [1, 7] }
  let(:destination) { [3, 7] }
  let(:removed) { [2, 4] }

  subject(:move) { described_class.new(position, destination) }

  describe '#initialize' do
    context 'when called with two arguments' do
      it 'creates an object with no removed position' do
        expect(move.removed).to be_nil
      end

      it 'creates an object with @promotion as false' do
        result = move.instance_variable_get(:@promotion)
        expect(result).to be false
      end

      it 'creates an object with @en_passant attribute as false' do
        result = move.instance_variable_get(:@en_passant)
        expect(result).to be false
      end

      it 'creates an object with @castle attribute as false' do
        result = move.instance_variable_get(:@castle)
        expect(result).to be false
      end
    end

    context 'when called with three arguments' do
      subject(:move) { described_class.new(position, destination, removed) }

      it 'creates an object with @removed which is the third argument' do
        result = move.instance_variable_get(:@removed)
        expect(result).to eq(removed)
      end
    end
  end

  describe '#removed' do
    context 'when called' do
      subject(:move) { described_class.new(position, destination, removed) }

      it 'returns the third argument during initialization' do
        expect(move.removed).to eq(removed)
      end
    end
  end

  describe '#moved' do
    context 'when called' do
      it 'returns @moved atrribute' do
        moved = move.instance_variable_get(:@moved)
        expect(move.moved).to eq(moved)
      end
    end
  end

  describe '#add_move' do
    context 'when called with position and destination' do
      it 'adds it to the list of moves' do
        position = [0, 0]
        destination = [99, 99]
        move.add_move(from: position, destination: destination)
        expect(move.moved[position]).to eq(destination)
      end
    end
  end

  describe '#destination_for' do
    let(:position) { [0, 0] }
    let(:destination) { [99, 99] }

    before { move.add_move(from: position, destination: destination) }

    context 'when called with a valid position' do
      it 'returns the destination for the position' do
        result = move.destination_for(from: position)
        expect(result).to eq(destination)
      end
    end
  end

  describe '#to_s' do
    context 'when called' do
      it 'returns the correct string representation' do
        expected = "|h7 => h5|"
        expect(move.to_s).to eq(expected)
      end
    end
  end

  describe '#convert_move' do
    context 'when called with a move notation (e.g d2d4 or 0-0-0)' do
      let(:board) { Board.new }
      let(:move_notation) { 'd2d4' }

      it 'returns a move that corresponds to the notation' do
        move = Move.convert_move(move: move_notation, board: board)
        expected_destination = [4, 3]
        expect(move.destination_for([6, 3])).to eq(expected_destination)
      end
    end

    context 'when called with a move notation that captures a piece' do
      let(:board) { Board.new(fen_notation: '8/p7/1P6/8/8/8/8/8') }
      let(:move_notation) { 'b3a2' }

      it 'returns a move that removes the captured piece' do
        move = Move.convert_move(move: move_notation, board: board)
        removed_piece_pos = [1, 0]
        expect(move.removed).to eq(removed_piece_pos)
      end
    end

    context 'when called with a kingside castling move notation i.e O-O' do
      let(:board) { Board.new(fen_notation: '8/p7/1P6/8/8/8/8/4K2R') }
      let(:move_notation) { 'O-O' }
      subject(:move) { Move.convert_move(move: move_notation, board: board) }

      it 'returns the correct castling move' do
        king_destination = [7, 6]
        rook_destination = [7, 5]

        expect(move.destination_for([7, 4])).to eq(king_destination)
        expect(move.destination_for([7, 7])).to eq(rook_destination)
      end

      it 'returns a castling move' do
        expect(move.castling).to be true
      end
    end
  end
end

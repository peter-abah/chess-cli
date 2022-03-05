# frozen_string_literal: true

require_relative '../lib/move_converter'

describe MoveConverter do
  xdescribe '#convert_move' do
    context 'when called with a move notation (e.g d2d4 or 0-0-0)' do
      let(:board) { Board.new }
      let(:move_notation) { 'd2d4' }

      it 'returns a move that corresponds to the notation' do
        move = MoveConverter.convert_move(move: move_notation, board: board)
        expected_destination = [4, 3]
        expect(move.destination_for([6, 3])).to eq(expected_destination)
      end
    end

    context 'when called with a move notation that captures a piece' do
      let(:board) { Board.new(fen_notation: '8/p7/1P6/8/8/8/8/8') }
      let(:move_notation) { 'b3a2' }

      it 'returns a move that removes the captured piece' do
        move = MoveConverter.convert_move(move: move_notation, board: board)
        removed_piece_pos = [1, 0]
        expect(move.removed).to eq(removed_piece_pos)
      end
    end

    context 'when called with a kingside castling move notation i.e O-O' do
      let(:board) { Board.new(fen_notation: '8/p7/1P6/8/8/8/8/4K2R') }
      let(:move_notation) { 'O-O' }
      subject(:move) { MoveConverter.convert_move(move: move_notation, board: board) }

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
# frozen_string_literal: true

require_relative '../../lib/pieces/king'

describe King do
  let(:color) { 'white' }
  subject(:king) { described_class.new(color) }

  describe '#color' do
    context 'when called' do
      it 'returns the correct color for the piece' do
        expect(king.color).to eq(color)
      end
    end
  end

  describe '#move_sets' do
    it 'returns the correct move_sets' do
      move_set, = king.move_sets
      expected_increments = [{ y: -1, x: -1 }, { y: 1, x: 1 }, { y: 1, x: -1 },
                             { y: -1, x: 1 }, { y: 0, x: -1 }, { y: 0, x: 1 },
                             { y: -1, x: 0 }, { y: 1, x: 0 }]

      expect(king.move_sets.size).to eq 1
      expect(move_set.increments).to eq expected_increments
      expect(move_set.repeat).to eq 1
      expect(move_set.blocked_by).to eq :player_piece
      expect(move_set.special_moves).to eq %i[kingside_castle queenside_castle]
    end
  end

  # describe '#possible_moves' do
  #   context 'when king is at edge of board' do
  #     let(:board) { Board.new(fen_notation: '7k/8/8/8/8/8/8/8') }
  #     subject(:king) { board.piece_at(y: 0, x: 7) }

  #     it 'returns the correct moves' do
  #       expected = Set[{ [0, 7] => [0, 6] }, { [0, 7] => [1, 7] }, { [0, 7] => [1, 6] }]
  #       moves = king.possible_moves(board, [0, 7])
  #       result = moves.map(&:moved).to_set
  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when the king is at the center of the board' do
  #     let(:board) { Board.new(fen_notation: '8/8/8/3k4/8/8/8/8') }
  #     subject(:king) { board.piece_at(y: 3, x: 3) }

  #     it 'returns the correct moves' do
  #       array = king.possible_moves(board, [3, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [3, 3] => [3, 2] }, { [3, 3] => [3, 4] }, { [3, 3] => [2, 3] },
  #                      { [3, 3] => [4, 3] }, { [3, 3] => [2, 2] }, { [3, 3] => [4, 4] },
  #                      { [3, 3] => [2, 4] }, { [3, 3] => [4, 2] }]
  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there are enemy pieces blocking its path' do
  #     let(:board) { Board.new(fen_notation: '8/8/2P5/2PkP3/8/8/8/8') }
  #     subject(:king) { board.piece_at(y: 3, x: 3) }

  #     it 'returns moves that include enemy pieces' do
  #       array = king.possible_moves(board, [3, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [3, 3] => [3, 2] }, { [3, 3] => [3, 4] }, { [3, 3] => [2, 3] },
  #                      { [3, 3] => [4, 3] }, { [3, 3] => [2, 2] }, { [3, 3] => [4, 4] },
  #                      { [3, 3] => [2, 4] }, { [3, 3] => [4, 2] }]
  #       expect(result).to eq(expected)
  #     end

  #     it 'returns moves that capture the enemy pieces' do
  #       array = king.possible_moves(board, [3, 3])
  #       result = array.map(&:removed).reject(&:nil?).to_set
  #       expected = Set[[2, 2], [3, 2], [3, 4]]

  #       expect(result).to eq(expected)
  #     end
  #   end

  #   context 'when there are player pieces blocking the path' do
  #     let(:board) { Board.new(fen_notation: '8/8/2p5/2pkp3/8/8/8/8') }
  #     subject(:king) { board.piece_at(y: 3, x: 3) }

  #     it 'returns moves that does not include the player pieces positions' do
  #       array = king.possible_moves(board, [3, 3])
  #       result = array.map(&:moved).to_set
  #       expected = Set[{ [3, 3] => [4, 3] }, { [3, 3] => [4, 4] }, { [3, 3] => [2, 3] },
  #                      { [3, 3] => [2, 4] }, { [3, 3] => [4, 2] }]
  #       expect(result).to eq(expected)
  #     end

  #     it 'returns moves that do not capture any player piece' do
  #       array = king.possible_moves(board, [3, 3])
  #       result = array.map(&:removed).reject(&:nil?)
  #       expect(result).to be_empty
  #     end
  #   end

  #   context 'when castling is available on kingside' do
  #     let(:board) { Board.new(fen_notation: '4k2r/8/8/8/8/8/8/8') }
  #     subject(:king) { board.piece_at(y: 0, x: 4) }

  #     it 'returns moves that include a castling move' do
  #       array = king.possible_moves(board, [0, 4])
  #       result = array.map(&:moved)
  #       # expected = Set[{ [0, 4] => [0, 6], [0, 7] => [0, 5] }, { [0, 4] => [0, 5] },
  #       #                { [0, 4] => [0, 3] }, { [0, 4] => [1, 4] }, { [0, 4] => [1, 3] },
  #       #                { [0, 4] => [1, 5] }]
  #       expected = { [0, 4] => [0, 6], [0, 7] => [0, 5] }

  #       expect(result).to include(expected)
  #     end
  #   end

  #   context 'when castling is available on queenside' do
  #     let(:board) { Board.new(fen_notation: 'r3k3/8/8/8/8/8/8/8') }
  #     subject(:king) { board.piece_at(y: 0, x: 4) }

  #     it 'returns moves that include a castling move' do
  #       array = king.possible_moves(board, [0, 4])
  #       result = array.map(&:moved)
  #       # expected = Set[{ [0, 4] => [0, 2], [0, 0] => [0, 3] }, { [0, 4] => [0, 5] },
  #       #                { [0, 4] => [0, 3] }, { [0, 4] => [1, 4] }, { [0, 4] => [1, 3] },
  #       #                { [0, 4] => [1, 5] }]
  #       expected = { [0, 4] => [0, 2], [0, 0] => [0, 3] }

  #       expect(result).to include(expected)
  #     end
  #   end
  # end
end

# frozen_string_literal: true

require_relative '../../lib/rb_chess/pieces/bishop'
require_relative './piece_spec'

describe RbChess::Bishop do
  let(:position) { RbChess::Position.new(y: 1, x: 1) }
  subject(:bishop) { described_class.new('white', position) }
  
  it_behaves_like 'a chess piece', described_class

  describe '#move_sets' do
    it 'returns the correct move_sets' do
      move_set, = bishop.move_sets
      expected_increments = [{ y: 1, x: 1 }, { y: -1, x: 1 }, { y: -1, x: -1 },
                             { y: 1, x: -1 }]

      expect(bishop.move_sets.size).to eq 1
      expect(move_set.increments).to eq expected_increments
      expect(move_set.repeat).to eq Float::INFINITY
      expect(move_set.blocked_by).to eq [:same]
      expect(move_set.special_moves).to be_empty
      expect(move_set.promotable).to be false
    end
  end
end

# frozen_string_literal: true

require_relative '../../lib/rb_chess/pieces/pawn'
require_relative './piece_spec'

describe RbChess::Pawn do
  let(:position) { RbChess::Position.parse('a2') }
  subject(:pawn) { described_class.new(:white, position) }

  it_behaves_like 'a chess piece', described_class

  describe '#direction' do
    context 'when color is white' do
      subject(:pawn) { described_class.new(:white, position) }

      it 'returns -1' do
        expect(pawn.direction).to eq(-1)
      end
    end

    context 'when color is black' do
      subject(:pawn) { described_class.new(:black, position) }

      it 'returns 1' do
        expect(pawn.direction).to eq 1
      end
    end
  end

  describe '#move_sets' do
    it 'has a size of 2 elements' do
      expect(pawn.move_sets.size).to eq 2
    end

    it 'the first moveset is for normal moves' do
      move_set = pawn.move_sets.first
      expected_increments = [{ y: -1, x: 0 }]

      expect(move_set.increments).to eq expected_increments
      expect(move_set.repeat).to eq 2
      expect(move_set.blocked_by).to eq [:piece]
      expect(move_set.special_moves).to eq %i[en_passant]
      expect(move_set.promotable).to be true
    end

    it 'the second moveset is for capture moves' do
      move_set = pawn.move_sets.last
      expected_increments = [{ y: -1, x: 1 }, { y: -1, x: -1 }]

      expect(move_set.increments).to eq expected_increments
      expect(move_set.repeat).to eq 1
      expect(move_set.blocked_by).to contain_exactly(:empty, :same)
      expect(move_set.special_moves).to be_empty
      expect(move_set.promotable).to be true
    end

    context 'when color is black' do
      subject(:pawn) { described_class.new(:black, position) }

      it 'the y value for normal move increments is 1' do
        move_set = pawn.move_sets.first
        expected_increments = [{ y: 1, x: 0 }]
        expect(move_set.increments).to eq expected_increments
      end

      it 'the y value for capture move increments is 1' do
        move_set = pawn.move_sets.last
        expected_increments = [{ y: 1, x: 1 }, { y: 1, x: -1 }]
        expect(move_set.increments).to eq expected_increments
      end
    end

    context 'when the pawn position is not starting rank' do
      subject(:pawn) { described_class.new(:white, RbChess::Position.parse('a4')) }

      it 'the normal move_set has repeat as 1' do
        move_set = pawn.move_sets.first
        expect(move_set.repeat).to eq 1
      end
    end
  end

  describe '#can_promote?' do
    context 'when pawn color is white and position is at rank 8' do
      let(:pawn) { described_class.new(:white, RbChess::Position.parse('a7')) }

      it 'returns true' do
        expect(pawn.can_promote?(RbChess::Position.parse('a8'))).to be true
      end
    end

    context 'when pawn color is white and position is not at rank 8' do
      let(:pawn) { described_class.new(:white, RbChess::Position.parse('a5')) }

      it 'returns false' do
        expect(pawn.can_promote?(RbChess::Position.parse('a7'))).to be false
      end
    end

    context 'when pawn color is black and position is at rank 1' do
      let(:pawn) { described_class.new(:black, RbChess::Position.parse('a2')) }

      it 'returns true' do
        expect(pawn.can_promote?(RbChess::Position.parse('a1'))).to be true
      end
    end

    context 'when pawn color is black and position is not at rank 1' do
      let(:pawn) { described_class.new(:black, RbChess::Position.parse('a7')) }

      it 'returns false' do
        expect(pawn.can_promote?(RbChess::Position.parse('a5'))).to be false
      end
    end
  end

  describe '#promotion_pieces' do
    it 'returns the correct promotion pieces for pawn' do
      expect(pawn.promotion_pieces).to match_array %w[q b n r]
    end
  end
end

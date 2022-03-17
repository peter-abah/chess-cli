# frozen_string_literal: true

require_relative '../lib/rb_chess/move'
require_relative '../lib/rb_chess/position'

describe RbChess::Move do
  let(:from) { 'a1' }
  let(:to) { 'c6' }
  let(:removed) { 'c6' }

  subject(:move) { described_class.new(from: from, to: to) }

  describe '#removed' do
    context 'when removed is not specified during initialization' do
      let(:move) { described_class.new(from: from, to: to) }

      it 'returns nil' do
        expect(move.removed).to be_nil
      end
    end
    
    context 'when removed is specified during initialization' do
      let(:move) { described_class.new(from: from, to: to, removed: removed) }

      it 'returns the correct value' do
        expect(move.removed).to eq RbChess::Position.parse(removed)
      end
    end
  end

  describe '#moved' do
    context 'when called' do
      it 'returns an array containing from and to' do
        moved = move.moved
        expect(move.moved).to match_array(
          [{ from: RbChess::Position.parse(from), to: RbChess::Position.parse(to) }]
        )
      end
    end
  end

  describe '#add_move' do
    context 'when called with position and destination' do
      let(:from) { 'e4' }
      let(:to) { 'e6' }
 
      it 'adds it to the list of moves' do
        move.add_move(from: from, to: to)
        expect(move.moved).to include (
          { from: RbChess::Position.parse(from), to: RbChess::Position.parse(to) }
        )
      end
    end
  end

  describe '#to_s' do
    context 'when called for a normal move' do
      let(:move) { described_class.new(from: 'e2', to: 'e4') }
      
      it 'returns the correct Coordinate  format' do
        expect(move.to_s).to eq 'e2e4'
      end
    end
    
    context 'when called for a kingside castling move' do
      let(:move) { described_class.new(from: 'e1', to: 'g1', castle: :kingside) }
      
      it 'returns the correct Coordinate  format' do
        expect(move.to_s).to eq '0-0'
      end
    end
    
    context 'when called for a queenside castling move' do
      let(:move) { described_class.new(from: 'e1', to: 'c1', castle: :queenside) }
      
      it 'returns the correct Coordinate  format' do
        expect(move.to_s).to eq '0-0-0'
      end
    end
    
    context 'when called for a promotion move' do
      let(:move) { described_class.new(from: 'e7', to: 'e8', promotion: 'Q') }
      
      it 'returns the correct LAN format' do
        expected = "e7e8Q"
        expect(move.to_s).to eq(expected)
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../lib/move'
require_relative '../lib/position'

describe Move do
  let(:from) { Position.parse('a1') }
  let(:to) { Position.parse('c6') }
  let(:removed) { Position.parse('c6') }

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
        expect(move.removed).to eq removed
      end
    end
  end

  describe '#moved' do
    context 'when called' do
      it 'returns an array containing from and to' do
        moved = move.moved
        expect(move.moved).to match_array [{ from: from, to: to }]
      end
    end
  end
  
  describe '#destination_for' do
    context 'when called with a valid position' do
      it 'returns the destination for the position' do
        result = move.destination_for(from)
        expect(result).to eq to
      end
    end
  end

  describe '#add_move' do
    context 'when called with position and destination' do
      let(:from) { Position.parse('e4') }
      let(:to) { Position.parse('e6') }
 
      it 'adds it to the list of moves' do
        move.add_move(from: from, to: to)
        expect(move.moved).to include ({ from: from, to: to })
      end
    end
  end

  describe '#to_s' do
    context 'when called for a normal move' do
      let(:move) { Move.new(from: Position.parse('e2'), to: Position.parse('e4')) }
      
      it 'returns the correct LAN format' do
        expected = "e2e4"
        expect(move.to_s).to eq(expected)
      end
    end
    
    context 'when called for a kingside castling move' do
      let(:move) { Move.new(from: Position.parse('e1'), to: Position.parse('g1'), castle: :kingside) }
      
      it 'returns the correct LAN format' do
        expected = "0-0"
        expect(move.to_s).to eq expected
      end
    end
    
    context 'when called for a queenside castling move' do
      let(:move) { Move.new(from: Position.parse('e1'), to: Position.parse('c1'), castle: :queenside) }
      
      it 'returns the correct LAN format' do
        expected = "0-0-0"
        expect(move.to_s).to eq(expected)
      end
    end
    
    context 'when called for a promotion move' do
      let(:move) { Move.new(from: Position.parse('e7'), to: Position.parse('e8'), promotion: 'Q') }
      
      it 'returns the correct LAN format' do
        expected = "e7e8Q"
        expect(move.to_s).to eq(expected)
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../lib/position'

describe Position do
  subject(:position) { described_class.new(y: 0, x: 0) }

  describe '#y' do
    it 'should return the correct value' do
      expect(position.y).to eq 0
    end
  end
  
  describe '#x' do
    it 'should return the correct value' do
      expect(position.x).to eq 0
    end
  end
  
  describe '#to_s' do
    it 'should return the correct value' do
      expect(position.to_s).to eq 'a8'
    end
  end
  
  describe '#==' do
    it 'returns true if both positions have the same y and x values' do
      another_position = described_class.new(y: 0, x: 0)
      expect(position).to eq another_position
    end
    
    it 'returns false if both positions do not have the same y and x values' do
      another_position = described_class.new(y: 5, x: 4)
      expect(position).not_to eq another_position
    end
    
    it 'returns false if the argument is not a Position object' do
      expect(position).not_to eq 'a_string'
    end
  end
  
  describe '#increment' do
    context 'when passed y and x values' do
      it 'returns a new position that is incremented by the value' do
        new_position = position.increment(y: 1, x: 1)
        expect(new_position).to have_attributes(y: 1, x: 1)
      end
      
      it 'increases only y if it is the only argument' do
        new_position = position.increment(y: 1)
        expect(new_position).to have_attributes(y: 1, x: 0)
      end
      
      it 'does not change anything if no argument is passed' do
        new_position = position.increment
        expect(new_position).to have_attributes(y: 0, x: 0)
      end
    end
  end
  
  describe '::parse' do
    context 'when passed an algebraic notation for chess position i.e b5 or h7' do
      it 'returns the correct position for a1' do
        position = Position.parse('a1')
        expect(position).to have_attributes(y: 7, x: 0)
      end
      
      it 'returns the correct position for h8' do
        position = Position.parse('h8')
        expect(position).to have_attributes(y: 0, x: 7)
      end
      
      it 'raises' an error for invalid position'' do
        expect { Position.parse('i0') }.to raise_error StandardError
      end
    end
  end
end
# frozen_string_literal: true

require_relative '../lib/move'

describe Move do
  let(:position) { [1, 9] }
  let(:destination) { [3, 7] }
  let(:removed) { [2, 4] }

  subject(:move) { described_class.new(position, destination) }

  describe '#initialize' do
    context 'when called with two arguments' do
      it 'creates an object with @removed which is nil' do
        result = move.instance_variable_get(:@removed)
        expect(result).to be_nil
      end

      it 'creates an object with @moved which is a hash' do
        result = move.instance_variable_get(:@moved)
        expect(result).to be_a Hash
      end

      it '@moved atrribute has a key which is the first argument and the coreesponding value is the second argument' do
        moved = move.instance_variable_get(:@moved)
        result = moved[position]
        expect(result).to eq(destination)
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
      it 'returns @removed atrribute' do
        removed = move.instance_variable_get(:@removed)
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
end

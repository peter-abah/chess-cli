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
        move.add_move(position: position, destination:destination)
        expect(move.moved[position]).to eq(destination)
      end
    end
  end

  describe '#destination_for' do
    let(:position) { [0, 0] }
    let(:destination) { [99, 99] }

    before { move.add_move(position: position, destination: destination) }

    context 'when called with a valid position' do
      it 'returns the destination for the position' do
        result = move.destination_for(position: position)
        expect(result).to eq(destination)
      end
    end
  end
end

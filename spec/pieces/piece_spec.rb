# frozen_string_literal: true

require_relative '../../lib/position'

RSpec.shared_examples "a chess piece" do |klass|
  let(:position) { Position.new(y: 1, x: 1) }
  let(:color) { 'black' }
  subject(:piece) { klass.new(color, position) }

  describe '#color' do
    it 'returns the piece’s color' do
      expect(piece.color).to eq(color)
    end
  end
  
  describe '#position' do
    it 'returns the piece’s position' do
      expect(piece.position).to eq(position)
    end
  end
end

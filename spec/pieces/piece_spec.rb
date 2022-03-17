# frozen_string_literal: true

require_relative '../../lib/rb_chess/position'

RSpec.shared_examples "a chess piece" do |klass|
  let(:position) { RbChess::Position.new(y: 1, x: 1) }
  let(:color) { :black }
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
  
  describe '#update_position' do
    it 'returns a new piece with the new position' do
      new_pos = RbChess::Position.parse('a4')
      expect(piece.update_position(new_pos))
        .to have_attributes(position: new_pos, class: klass, color: piece.color)
    end
  end
end

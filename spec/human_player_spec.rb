# frozen_string_literal: true

require_relative '../lib/human_player'

describe HumanPlayer do
  let(:color) { 'white' }
  subject(:player) { described_class.new(color) }

  describe '#color' do
    it 'should return the correct color' do
      expect(player.color).to eq(color)
    end
  end
end

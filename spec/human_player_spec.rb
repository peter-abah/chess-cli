# frozen_string_literal: true

require_relative '../lib/human_player'
require_relative '../lib/board'

describe HumanPlayer do
  let(:color) { 'white' }
  subject(:player) { described_class.new(color) }

  describe '#color' do
    it 'should return the correct color' do
      expect(player.color).to eq(color)
    end
  end

  describe '#play_move' do
    let(:board) { Board.new }

    context 'when called with a board' do
      it 'should return a move' do
        move = player.play_move(board)
        expect(move).to be_a Move
      end
    end
  end
end

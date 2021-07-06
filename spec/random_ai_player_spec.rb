# frozen_string_literal: true

require_relative '../lib/random_ai_player'
require_relative '../lib/board'

describe RandomAIPlayer do
  subject(:random_ai) { described_class.new('white') }

  describe '#play_move' do
    context 'when called with a starting board' do
      it 'returns a random legal move' do
        board = Board.new
        p random_ai.play_move(board)
      end
    end
  end
end

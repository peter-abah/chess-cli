# frozen_string_literal: true

require_relative '../lib/game_func'
require_relative '../lib/board'

describe GameFunc do
  describe '#check?' do
    let(:dummy_class) { Class.new { extend GameFunc} }

    context 'when called for white player with a starting board' do
      it 'returns false' do
        board = Board.new
        player = double(color: 'white')
        result = dummy_class.check?(player, board)
        expect(result).to be false
      end
    end

    context 'when called for black player with a starting board' do
      it 'returns false' do
        board = Board.new
        player = double(color: 'black')
        result = dummy_class.check?(player, board)
        expect(result).to be false
      end
    end
  end
end

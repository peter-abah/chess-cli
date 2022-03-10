# frozen_string_literal: true

require 'require_all'

require_relative 'board_matchers'
require_relative '../lib/board'
require_relative '../lib/position'
require_rel '../lib/pieces'

describe Board do
  subject(:board) { described_class.new }

  describe '#piece_at' do
    context 'when called with position a2' do
      it 'should return a white Pawn' do
        piece = board.piece_at(Position.parse('a2'))
        expect(piece).to be_a(Pawn).and have_attributes(color: :white)
      end
    end
    
    context 'when called with position e8' do
      it 'should return a black King' do
        piece = board.piece_at(Position.parse('e8'))
        expect(piece).to be_a(King).and have_attributes(color: :black)
      end
    end
    
    context 'when called with position h4' do
      it 'should return nil' do
        piece = board.piece_at(Position.parse('h4'))
        expect(piece).to be_nil
      end
    end
  end
  
  describe '#pieces' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns pieces for a starting chess board at their default positions' do
        expect(board.pieces).to have_all_pieces_at_default_positions
      end
    end
    
    context 'when board is initialized with a segments hash' do
      segments = { pieces: [Rook.new(:white, Position.parse('a3'))] }
      let(:board) { described_class.new(segments: segments) }
 
      it 'returns the pieces set in the segments hash' do
        expect(board.pieces).to contain_exactly(
          be_a(Rook).and have_attributes(color: :white, position: Position.parse('a3'))
        )
      end
    end
    
    context 'when board is initialized with fen notation' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 w - - 0 1') }
 
      it 'returns the pieces set in the segments hash' do
        expect(board.pieces).to contain_exactly(
          be_a(Rook).and have_attributes(color: :white, position: Position.parse('a3'))
        )
      end
    end
  end
end

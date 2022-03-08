# frozen_string_literal: true

require_relative '../lib/fen_parser'
require_relative '../lib/position'
require_rel '../lib/pieces'

describe FENParser do
  subject(:default_fen) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR' }

  describe '#fen_notation' do
    context 'when called when it is initialized with no arguments' do
      subject(:fen_parser) { described_class.new }

      it 'should return the default fen notation' do
        expect(fen_parser.fen_notation).to eq(default_fen)
      end
    end

    context 'when called when it is initialized with an argument' do
      let(:fen_notation) { 'random string' }
      subject(:fen_parser) { described_class.new(fen_notation) }

      it 'should return the argument it was initialized with' do
        expect(fen_parser.fen_notation).to eq(fen_notation)
      end
    end
  end

  describe '#parse' do
    context 'when called for a valid fen' do
      let(:valid_notation) { '8/8/8/r7/8/8/8/8' }
      let(:fen_parser) { described_class.new(valid_notation) }

      it 'should return an array containing the correct pieces' do
        result = fen_parser.parse
        expect(result).to contain_exactly(be_a(Rook).and(have_attributes(color: 'black')))
      end

      it 'the piece should have the correct position' do
        piece_pos = fen_parser.parse[0].position

        expect(piece_pos).to have_attributes(y: 3, x: 0)
      end
    end

    context 'when called for an invalid fen' do
      let(:invalid_notation) { '3/8/1/3/asdfghjk/10d/8/pppppppp/8' }
      subject(:fen_parser) { described_class.new(:invalid_fen) }

      it 'should raise an Error' do
        expect { fen_parser.parse }.to raise_error StandardError
      end
    end
  end
  
  describe '::pieces_to_fen' do
    context 'when called with an array containing one black rook at a8' do
      let(:pieces) { [Pawn.new('white', Position.parse('a8'))] }
      
      it 'should return the valid fen notation' do
        expected_fen_notation = 'P7/8/8/8/8/8/8/8'

        fen_notation = described_class.pieces_to_fen(pieces)
        expect(fen_notation).to eq expected_fen_notation
      end
    end
    
    context 'when there are more than one pieces' do
      let(:pieces) { [
        Pawn.new('black', Position.parse('e4')),
        Knight.new('white', Position.parse('d1'))
      ] }

      it 'should return the valid fen notation' do
        expected_fen_notation = '8/8/8/8/4p3/8/8/3N4'

        fen_notation = described_class.pieces_to_fen(pieces)
        expect(fen_notation).to eq expected_fen_notation
      end
    end
    
    context 'when there are more than one piece on a rank' do
      let(:pieces) do
        (0..7).map { |x| Pawn.new('black', Position.new(y: 1, x: x)) }
      end
 
      it 'should return the valid fen notation' do
        expected_fen_notation = '8/pppppppp/8/8/8/8/8/8'

        fen_notation = described_class.pieces_to_fen(pieces)
        expect(fen_notation).to eq expected_fen_notation
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../lib/fen_parser'

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
      let(:notation) { '8/8/8/r7/8/8/8/8' }
      let(:fen_parser) { described_class.new(notation) }

      it 'should return an 8 x 8 multidimensional array' do
        result = fen_parser.parse

        expect(result.length).to eq(8)
        expect(result).to all(be_a Array)
        expect(result).to all(have(8).items)
      end
    end
  end
end

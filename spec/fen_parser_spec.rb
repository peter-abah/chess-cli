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
end

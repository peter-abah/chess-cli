# frozen_string_literal: true

require_relative '../lib/fen_parser'
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

      it 'should return an 8 x 8 multidimensional array' do
        result = fen_parser.parse

        expect(result.length).to eq(8)
        expect(result).to all(be_a Array)
        expect(result).to all(have(8).items)
      end

      it 'should return a correct representation of the board' do
        piece = fen_parser.parse[3][0]
        empty = fen_parser.parse[7][7]

        expect(piece).to be_a Rook
        expect(empty).to be_nil
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

  # class method
  describe '#board_to_fen' do
    context 'when called with a board array' do
      it 'should return the valid fen notation' do
        board = Array.new(8) { Array.new(8) }
        board[0][0] = Pawn.new('white')
        expected_fen_notation = 'P7/8/8/8/8/8/8/8'

        fen_notation = described_class.board_to_fen(board: board)
        expect(fen_notation).to eq expected_fen_notation
      end

      it 'should return the valid fen notation' do
        board = Array.new(8) { Array.new(8) }
        board[7][7] = Pawn.new('black')
        expected_fen_notation = '8/8/8/8/8/8/8/7p'

        fen_notation = described_class.board_to_fen(board: board)
        expect(fen_notation).to eq expected_fen_notation
      end

      it 'should return the valid fen notation' do
        board = Array.new(8) { Array.new(8) }
        board[4][4] = Pawn.new('black')
        board[7][3] = Knight.new('white')
        expected_fen_notation = '8/8/8/8/4p3/8/8/3N4'

        fen_notation = described_class.board_to_fen(board: board)
        expect(fen_notation).to eq expected_fen_notation
      end

      it 'should return the valid fen notation' do
        board = Array.new(8) { Array.new(8) }
        board[1] = Array.new(8) { Pawn.new('black') }
        expected_fen_notation = '8/pppppppp/8/8/8/8/8/8'

        fen_notation = described_class.board_to_fen(board: board)
        expect(fen_notation).to eq expected_fen_notation
      end
    end
  end
end

# frozen_string_literal: true

require 'require_all'

require_relative 'board_matchers'
require_relative '../lib/rb_chess/board'
require_relative '../lib/rb_chess/position'
require_relative '../lib/rb_chess/move'
require_relative '../lib/rb_chess/castling_rights'
require_rel '../lib/rb_chess/pieces'

describe RbChess::Board do
  subject(:board) { described_class.new }

  describe '#piece_at' do
    context 'when called with position a2' do
      it 'should return a white Pawn' do
        piece = board.piece_at('a2')
        expect(piece).to be_a(RbChess::Pawn).and have_attributes(color: :white)
      end
    end

    context 'when called with position e8' do
      it 'should return a black King' do
        piece = board.piece_at('e8')
        expect(piece).to be_a(RbChess::King).and have_attributes(color: :black)
      end
    end

    context 'when called with position h4' do
      it 'should return nil' do
        piece = board.piece_at('h4')
        expect(piece).to be_nil
      end
    end
  end

  describe '#to_fen' do
    it 'returns fen notation of board' do
      expect(board.to_fen).to eq 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0'
    end
  end

  describe '#ascii' do
    subject(:board) { described_class.new }

    it 'returns the ascii representation of the board' do
      expect(board.ascii).to eq(
        <<~BOARD.chomp
             a b c d e f g h
            _________________
          8  r n b q k b n r  8
          7  p p p p p p p p  7
          6  - - - - - - - -  6
          5  - - - - - - - -  5
          4  - - - - - - - -  4
          3  - - - - - - - -  3
          2  P P P P P P P P  2
          1  R N B Q K B N R  1
            _________________
             a b c d e f g h
        BOARD
      )
    end
  end

  describe '#pieces' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns pieces for a starting chess board at their default positions' do
        expect(board.pieces).to have_all_pieces_at_default_positions
      end
    end

    context 'when board is initialized with fen notation' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 w - - 0 1') }

      it 'returns the pieces set in the fen notation' do
        expect(board.pieces).to contain_exactly(
          be_a(RbChess::Rook).and(have_attributes(color: :white, position: RbChess::Position.parse('a3')))
        )
      end
    end
  end

  describe '#active_color' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns white' do
        expect(board.active_color).to eq :white
      end
    end

    context 'when board is initialized with a fen notation with active color set to black' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 b - - 0 1') }

      it 'returns black' do
        expect(board.active_color).to eq :black
      end
    end
  end

  describe '#en_passant_square' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns nil' do
        expect(board.en_passant_square).to be_nil
      end
    end

    context 'when board is initialized with a fen notation with en_passant_square set to f5' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 b - f5 0 1') }

      it 'returns f5 position' do
        expect(board.en_passant_square).to eq RbChess::Position.parse('f5')
      end
    end
  end

  describe 'can_castle_kingside?' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns true for white' do
        expect(board.can_castle_kingside?(:white)).to be true
      end

      it 'returns true for black' do
        expect(board.can_castle_kingside?(:black)).to be true
      end
    end

    context 'when board is initialized with fen notation with kingside castling set only for black' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 b kq - 0 1') }

      it 'returns false for white' do
        expect(board.can_castle_kingside?(:white)).to be false
      end

      it 'returns true for black' do
        expect(board.can_castle_kingside?(:black)).to be true
      end
    end
  end

  describe 'can_castle_queenside?' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns true for white' do
        expect(board.can_castle_queenside?(:white)).to be true
      end

      it 'returns true for black' do
        expect(board.can_castle_queenside?(:black)).to be true
      end
    end

    context 'when board is initialized with fen notation with queenside castling set only for white' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 b Q - 0 1') }

      it 'returns true for white' do
        expect(board.can_castle_queenside?(:white)).to be true
      end

      it 'returns false for black' do
        expect(board.can_castle_queenside?(:black)).to be false
      end
    end
  end

  describe '#halfmove_clock' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns 0' do
        expect(board.halfmove_clock).to eq 0
      end
    end

    context 'when board is initialized with a fen notation with halfmove_clock set to 1' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 b - f5 1 1') }

      it 'returns 1' do
        expect(board.halfmove_clock).to eq 1
      end
    end
  end

  describe '#fullmove_no' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns 0' do
        expect(board.fullmove_no).to eq 0
      end
    end

    context 'when board is initialized with a fen notation with fullmove_no set to 99' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 b - f5 1 99') }

      it 'returns 1' do
        expect(board.fullmove_no).to eq 99
      end
    end
  end

  describe '#player_pieces' do
    it 'returns pieces for the particular color' do
      expect(board.player_pieces(:white)).to(
        all(have_attributes(color: :white)).and(have_attributes(size: 16))
      )
    end
  end

  describe '#make_move' do
    context 'when called with a move that moves pawn from a2 to a4' do
      let(:move) do
        RbChess::Move.new(from: 'a2', to: 'a4')
      end
      let(:new_board) { board.make_move(move) }

      it 'returns a new board with the updated pieces' do
        expect(new_board.piece_at('a2')).to be_nil
        expect(new_board.piece_at('a4')).to(
          be_a(RbChess::Pawn).and(have_attributes(color: :white))
        )
      end

      it 'the halfmove_clock remains board halfmove_clock' do
        expect(new_board.halfmove_clock).to eq board.halfmove_clock
      end

      it 'the fullmove_no remains the same' do
        expect(new_board.fullmove_no).to eq board.fullmove_no
      end

      it 'the active color becomes black' do
        expect(new_board.active_color).to eq :black
      end

      it 'the en passant square is set to a3' do
        expect(new_board.en_passant_square).to eq RbChess::Position.parse('a3')
      end

      it 'the castling_rights remain the same' do
        expect(new_board.can_castle_kingside?(:white)).to eq true
        expect(new_board.can_castle_kingside?(:black)).to eq true
        expect(new_board.can_castle_queenside?(:white)).to eq true
        expect(new_board.can_castle_queenside?(:black)).to eq true
      end
    end

    context 'when the move is a promotion move' do
      let(:board) { described_class.new(fen_notation: '8/P7/8/8/8/8/8/8 w - - 3 5') }
      let(:move) do
        RbChess::Move.new(from: 'a7', to: 'a8', promotion: 'Q')
      end

      it 'promotes the piece' do
        new_board = board.make_move move
        expect(new_board.piece_at('a8')).to(
          be_a(RbChess::Queen).and(have_attributes(color: :white))
        )
        expect(new_board.piece_at('a7')).to be_nil
      end
    end

    context 'when the move moves a white king' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/8/8/R3K2R w KQ - 3 5') }
      let(:move) do
        RbChess::Move.new(from: 'e1', to: 'e2')
      end

      it 'invalidates castling for white' do
        new_board = board.make_move move

        expect(new_board.can_castle_kingside?(:white)).to eq false
        expect(new_board.can_castle_queenside?(:white)).to eq false
      end
    end

    context 'when the move moves a kingside white rook' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/8/8/R3K2R w KQ - 3 5') }
      let(:move) do
        RbChess::Move.new(from: 'h1', to: 'h2')
      end

      it 'invalidates kingside castling for white' do
        new_board = board.make_move move

        expect(new_board.can_castle_kingside?(:white)).to eq false
        expect(new_board.can_castle_queenside?(:white)).to eq true
      end
    end

    context 'when the move moves a queenide white rook' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/8/8/R3K2R w KQ - 3 5') }
      let(:move) do
        RbChess::Move.new(from: 'a1', to: 'a2')
      end

      it 'invalidates queenside castling for white' do
        new_board = board.make_move move

        expect(new_board.can_castle_kingside?(:white)).to eq true
        expect(new_board.can_castle_queenside?(:white)).to eq false
      end
    end

    context 'when the move moves a black king' do
      let(:board) { described_class.new(fen_notation: 'r3k2r/8/8/8/8/8/8/8 b kq - 3 5') }
      let(:move) do
        RbChess::Move.new(from: 'e8', to: 'e7')
      end

      it 'invalidates castling for black' do
        new_board = board.make_move move
        expect(new_board.can_castle_kingside?(:black)).to eq false
        expect(new_board.can_castle_queenside?(:black)).to eq false
      end
    end

    context 'when the move moves a kingside black rook' do
      let(:board) { described_class.new(fen_notation: 'r3k2r/8/8/8/8/8/8/8 b kq - 3 5') }
      let(:move) do
        RbChess::Move.new(from: 'h8', to: 'h7')
      end

      it 'invalidates kingside castling for black' do
        new_board = board.make_move move

        expect(new_board.can_castle_kingside?(:black)).to eq false
        expect(new_board.can_castle_queenside?(:black)).to eq true
      end
    end

    context 'when the move moves a queenide black rook' do
      let(:board) { described_class.new(fen_notation: 'r3k2r/8/8/8/8/8/8/8 b kq - 3 5') }
      let(:move) do
        RbChess::Move.new(from: 'a8', to: 'a2')
      end

      it 'invalidates queenside castling for black' do
        new_board = board.make_move move

        expect(new_board.can_castle_kingside?(:black)).to eq true
        expect(new_board.can_castle_queenside?(:black)).to eq false
      end
    end

    context 'when the move does not move a pawn and is not a capture move' do
      let(:board) { described_class.new }
      let(:move) { RbChess::Move.new(from: 'g1', to: 'f3') }

      it 'increases halfmove_clock by 1' do
        new_board = board.make_move move
        expect(new_board.halfmove_clock).to eq board.halfmove_clock + 1
      end
    end

    context 'when black moves' do
      let(:board) { described_class.new(fen_notation: '8/p7/8/8/8/8/8/8 b - - 0 1') }
      let(:move) { RbChess::Move.new(from: 'a7', to: 'a6') }

      it 'increases fullmove_no by 1' do
        new_board = board.make_move move
        expect(new_board.fullmove_no).to eq board.fullmove_no + 1
      end
    end

    context 'when the move is a capture move' do
      let(:board) { described_class.new(fen_notation: '8/p7/8/8/R7/8/8/8 w - - 0 1') }
      let(:move) { RbChess::Move.new(from: 'a4', to: 'a7', removed: 'a7') }

      it 'increases removes the captured piece' do
        new_board = board.make_move move
        expect(new_board.pieces.size).to eq 1
      end
    end
  end
end

# frozen_string_literal: true

require 'require_all'

require_relative 'board_matchers'
require_relative '../lib/board'
require_relative '../lib/position'
require_relative '../lib/castling_rights'
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
  
  describe '#active_color' do
    context 'when board is initialized without arguments' do
      let(:board) { described_class.new }

      it 'returns white' do
        expect(board.active_color).to eq :white
      end
    end
    
    context 'when board is initialized with a segments hash' do
      segments = { active_color: :black }
      let(:board) { described_class.new(segments: segments) }
 
      it 'returns the active_color set in segments hash' do
        expect(board.active_color).to eq :black
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
    
    context 'when board is initialized with a segments hash' do
      segments = { en_passant_square: Position.parse('e4') }
      let(:board) { described_class.new(segments: segments) }
 
      it 'returns the en_passant_square set in segments hash' do
        expect(board.en_passant_square).to eq Position.parse('e4')
      end
    end
    
    context 'when board is initialized with a fen notation with en_passant_square set to f5' do
      let(:board) { described_class.new(fen_notation: '8/8/8/8/8/R7/8/8 b - f5 0 1') }
 
      it 'returns f5 position' do
        expect(board.en_passant_square).to eq Position.parse('f5')
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
    
    context 'when board is initialized with a segments hash' do
      segments = { halfmove_clock: 10 }
      let(:board) { described_class.new(segments: segments) }
 
      it 'returns the halfmove_clock set in segments hash' do
        expect(board.halfmove_clock).to eq 10
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
    
    context 'when board is initialized with a segments hash' do
      segments = { fullmove_no: 5 }
      let(:board) { described_class.new(segments: segments) }
 
      it 'returns the fullmove_no set in segments hash' do
        expect(board.fullmove_no).to eq 5
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
end

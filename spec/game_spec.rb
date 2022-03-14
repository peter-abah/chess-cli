# frozen_string_literal: true

require 'require_all'

require_relative '../lib/game'
require_rel './game_modules'

describe Game do
  it_behaves_like 'move generator'
  
  describe '#make_move' do
    context 'When given a valid move' do
      subject(:game) { described_class.new }
      
      it 'updates the game' do
        game.make_move 'a2a4'
        expect(game.board.to_fen).to eq 'rnbqkbnr/pppppppp/8/8/P7/8/1PPPPPPP/RNBQKBNR b KQkq a3 0 0'
      end
    end
    
    context 'When given an invalid move' do
      subject(:game) { described_class.new }
      
      it 'throws error' do
        expect { game.make_move 'a2a5' }.to raise_error ChessError
      end
    end
    
    context 'when given a move that can cause check' do
      subject(:game) { described_class.new(fen: '4r3/k7/8/8/8/5q2/4P3/4K3 w - - 0 4') }
      
      it 'throws error' do
        expect { game.make_move 'e2f3' }.to raise_error ChessError
      end
    end
    
    context 'kingside castling' do
      context 'when kingside castling is possible' do
        subject(:game) { described_class.new(fen: '4r3/k7/8/8/8/8/4P3/4K2R w K - 0 4') }
        
        it 'updates the game' do
          game.make_move '0-0'
          expect(game.board.to_fen).to eq '4r3/k7/8/8/8/8/4P3/5RK1 b - - 1 4'
        end
      end

      context 'when there is no kingside castling right' do
        subject(:game) { described_class.new(fen: '4r3/k7/8/8/8/8/4P3/4K2R w - - 0 4') }
        
        it 'raises an error' do
          expect { game.make_move '0-0' }.to raise_error ChessError
        end
      end

      context 'when the king is in check' do
        subject(:game) { described_class.new(fen: '4r3/k7/8/8/8/4r3/8/4K2R w K - 0 4') }
        
        it 'raises error' do
          expect{ game.make_move '0-0' }.to raise_error ChessError
        end
      end

      context 'when the castling positions are attacked' do
        subject(:game) { described_class.new(fen: '5r2/k7/8/8/8/8/8/4K2R w K - 0 4') }
        
        it 'raises error' do
          expect{ game.make_move '0-0' }.to raise_error ChessError
        end
      end

      context 'when there is a piece in the castling positions' do
        subject(:game) { described_class.new(fen: '8/k7/8/8/8/8/8/4KP1R w K - 0 4') }
        
        it 'raises error' do
          expect{ game.make_move '0-0' }.to raise_error ChessError
        end
      end
    end

    context 'queenside castling' do
      context 'when queenside castling is possible' do
        subject(:game) { described_class.new(fen: '4r3/k7/8/8/8/8/4P3/R3K3 w Q - 0 4') }
        
        it 'updates the game' do
          game.make_move '0-0-0'
          expect(game.board.to_fen).to eq '4r3/k7/8/8/8/8/4P3/2KR4 b - - 1 4'
        end
      end

      context 'when there is no queenside castling right' do
        subject(:game) { described_class.new(fen: '4r3/k7/8/8/8/8/4P3/R3K3 w - - 0 4') }
        
        it 'raises an error' do
          expect { game.make_move '0-0-0' }.to raise_error ChessError
        end
      end

      context 'when the king is in check' do
        subject(:game) { described_class.new(fen: '4r3/k7/8/8/8/4r3/8/R2K3 w Q - 0 4') }
        
        it 'raises error' do
          expect{ game.make_move '0-0-0' }.to raise_error ChessError
        end
      end

      context 'when the castling positions are attacked' do
        subject(:game) { described_class.new(fen: '3r4/k7/8/8/8/8/8/R3K3 w Q - 0 4') }
        
        it 'raises error' do
          expect{ game.make_move '0-0-0' }.to raise_error ChessError
        end
      end

      context 'when there is a piece in the castling positions' do
        subject(:game) { described_class.new(fen: '8/k7/8/8/8/8/8/RP2K3 w Q - 0 4') }
        
        it 'raises error' do
          expect{ game.make_move '0-0-0' }.to raise_error ChessError
        end
      end
    end
  end  
end














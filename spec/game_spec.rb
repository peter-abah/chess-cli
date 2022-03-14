# frozen_string_literal: true

require 'pry-byebug'
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

    context 'when given promotion moves' do
      subject(:game) { described_class.new(fen: '4r3/3P4/4k3/8/8/8/4P3/5K2 w - - 0 4') }
      
      it 'promotes the piece' do
        game.make_move 'd7e8R'
        expect(game.board.to_fen).to eq '4R3/8/4k3/8/8/8/4P3/5K2 b - - 0 4'
      end
    end

    context 'when promotion piece is not added to move' do
      subject(:game) { described_class.new(fen: '4r3/3P4/4k3/8/8/8/4P3/5K2 w - - 0 4') }
      
      it 'raises error' do
        expect { game.make_move 'd7e8' }.to raise_error ChessError
      end
    end
  end

  describe '#current_player' do
    subject(:game) { described_class.new }
    
    it 'returns the color of the player whose turn it is' do
      expect(game.current_player).to eq(:white)
    end

    context 'After a move' do
      subject(:game) { described_class.new }

      before { game.make_move 'a2a3'}

      it 'changes the current player' do
        expect(game.current_player).to eq :black
      end
    end
  end

  describe '#stalemate?' do
    context 'when there is no stalemate' do
      subject(:game) { described_class.new }
      
      it 'returns false' do
        expect(game.stalemate?).to be false
      end
    end

    context 'when there are no valid moves and no check' do
      subject(:game) { described_class.new(fen: '8/k7/8/8/8/6q1/7p/7K w - - 2 5') }
      
      it 'returns true' do
        expect(game.stalemate?).to be true
      end
    end
  end

  describe '#make_moves' do
    subject(:game) { described_class.new }

    it 'updates the game with the moves given alternating the colors' do
      game.make_moves(['e2e4', 'd7d5', 'b1c3'])
      expect(game.board.to_fen).to eq 'rnbqkbnr/ppp1pppp/8/3p4/4P3/2N5/PPPP1PPP/R1BQKBNR b KQkq - 1 1'
    end
  end

  describe 'threefold?' do
    context 'when a position has been repeated 3 times' do
      subject(:game) { described_class.new }
      
      # moves the knights back and forth to get the starting position three times
      before do
        game.make_moves([
          'b1c3', 'b8c6', 'c3b1', 'c6b8',
          'b1c3', 'b8c6', 'c3b1', 'c6b8',
          'b1c3',
        ])
      end

      it 'returns true' do
        expect(game.threefold?).to be true
      end
    end

    context 'when a position has not been repeated 3 times' do
      subject(:game) { described_class.new }
      
      it 'returns false' do
        expect(game.threefold?).to be false
      end
    end
  end

  describe 'fivefold?' do
    context 'when a position has been repeated 3 times' do
      subject(:game) { described_class.new }
      
      # moves the knights back and forth to get the starting position five times
      before do
        game.make_moves([
          'b1c3', 'b8c6', 'c3b1', 'c6b8',
          'b1c3', 'b8c6', 'c3b1', 'c6b8',
          'b1c3', 'b8c6', 'c3b1', 'c6b8',
          'b1c3', 'b8c6', 'c3b1', 'c6b8',
          'b1c3',
        ])
      end

      it 'returns true' do
        expect(game.fivefold?).to be true
      end
    end

    context 'when a position has not been repeated 3 times' do
      subject(:game) { described_class.new }
      
      it 'returns false' do
        expect(game.fivefold?).to be false
      end
    end
  end
end

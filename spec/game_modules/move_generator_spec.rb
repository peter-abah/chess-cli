# frozen_string_literal: true

RSpec.shared_examples "move generator" do
  describe '#all_moves' do
    subject(:game) { described_class.new }
    
    it 'returns all possible moves' do
      expect(game.all_moves).to contain_exactly(
        'a2a3', 'a2a4', 'b2b3', 'b2b4', 'c2c3', 'c2c4', 'd2d3', 'd2d4',
        'e2e3', 'e2e4', 'f2f3', 'f2f4', 'g2g3', 'g2g4', 'h2h3', 'h2h4',
        'b1a3', 'b1c3', 'g1h3', 'g1f3'
      )
    end
  end

  describe '#moves_at' do
    context 'When the game is at starting positions' do
      subject(:game) { described_class.new }
      
      it 'returns correct move for pawn at a2' do
        moves = game.moves_at('a2')
        expect(moves).to contain_exactly('a2a3', 'a2a4')
      end
      
      it 'returns the correct move for knight' do
        moves = game.moves_at('b1')
        expect(moves).to contain_exactly('b1a3', 'b1c3')
      end
      
      it 'returns empty for pieces that cannot movw' do
        moves = game.moves_at('a1')
        expect(moves).to be_empty
      end
      
      it 'returns empty for black pieces' do
        moves = game.moves_at('b7')
        expect(moves).to be_empty
      end
    end
    
    describe 'moves for pawn' do
      context 'when pawn has moved' do
        subject(:game) { described_class.new(fen: 'rnbqkbnr/p1pppppp/1p6/8/8/1PP5/P11PPPPP/RNBQKBNR b KQkq - 0 0') }
        
        it 'returns one move' do
          moves = game.moves_at('b6')
          expect(moves).to contain_exactly('b6b5')
        end
      end
      
      context 'when pawn can promote' do
        subject(:game) { described_class.new(fen: '8/P7/8/8/8/8/8/8 w - - 0 0') }
        
        it 'returns promotion moves' do
          moves = game.moves_at('a7')
          expect(moves).to contain_exactly('a7a8Q', 'a7a8R', 'a7a8N', 'a7a8B')
        end
      end
      
      context 'when pawn can capture' do
        subject(:game) { described_class.new(fen: '8/rrr5/1P6/8/8/8/8/8 w - - 0 0') }
        
        it 'returns capture moves' do
          moves = game.moves_at('b6')
          expect(moves).to contain_exactly('b6a7', 'b6c7')
        end
      end
      
      context 'when pawn can make en passant move' do
        subject(:game) { described_class.new(fen: '8/8/pP6/8/8/8/8/8 w - a7 0 0') }
        
        it 'returns capture moves' do
          moves = game.moves_at('b6')
          expect(moves).to contain_exactly('b6a7', 'b6b7')
        end
      end
      
      context 'the pawn does not capture same color pieces' do
        subject(:game) { described_class.new(fen: '8/R1P5/1P6/8/8/8/8/8 w - - 0 0') }
        
        it 'returns capture moves' do
          moves = game.moves_at('b6')
          expect(moves).to contain_exactly('b6b7')
        end
      end
    end
    
    describe 'moves for knight' do
      context 'when the piece is a knight' do
        subject(:game) { described_class.new(fen: '8/8/8/4N3/8/8/8/8 w - a7 0 0') }
        
        it 'returns the correct noves' do
          moves = game.moves_at('e5')
          expect(moves).to contain_exactly(
            'e5f7', 'e5g6', 'e5d7', 'e5c6', 'e5f3', 'e5g4', 'e5d3', 'e5c4'
          )
        end
      end
      
      context 'when knight is blocked' do
        subject(:game) { described_class.new(fen: '8/3P1P2/2N3N1/4N3/8/8/8/8 w - a7 0 0') }
        
        it 'returns moves without the blocked positions' do
          moves = game.moves_at('e5')
          expect(moves).to contain_exactly(
            'e5f3', 'e5g4', 'e5d3', 'e5c4'
          )
        end
      end
    end
    
    describe 'moves for bishop' do
      context 'when the piece is a bishop' do
        subject(:game) { described_class.new(fen: '8/8/8/4B3/8/8/8/8 w - a7 0 0') }
        
        it 'returns the correct noves' do
          moves = game.moves_at('e5')
          expect(moves).to contain_exactly(
            'e5f6', 'e5g7', 'e5h8', 'e5d6', 'e5c7', 'e5b8', 'e5f4', 'e5g3',
            'e5h2', 'e5d4', 'e5c3', 'e5b2', 'e5a1'
          )
        end
      end
      
      context 'when the bishop can capture' do
        subject(:game) { described_class.new(fen: '8/8/3q1q2/4B3/3q1q2/8/8/8 w - a7 0 0') }
        
        it 'returns the correct noves' do
          capture_moves = game.moves_at('e5')
          expect(capture_moves).to contain_exactly('e5f6', 'e5d6', 'e5d4', 'e5f4')
        end
      end
      
      context 'when bishop is blocked on all sides' do
        subject(:game) { described_class.new(fen: '8/8/3Q1Q2/4B3/3Q1Q2/8/8/8 w - a7 0 0') }
        
        it 'returns no moves' do
          moves = game.moves_at('e5')
          expect(moves).to be_empty
        end
      end
    end
    
    describe 'moves for rook' do
      context 'when the piece is a rook' do
        subject(:game) { described_class.new(fen: '8/8/8/4R3/8/8/8/8 w - a7 0 0') }
        
        it 'returns the correct moves' do
          moves = game.moves_at('e5')
          expect(moves).to contain_exactly(
            'e5a5', 'e5b5', 'e5c5', 'e5d5', 'e5f5', 'e5g5', 'e5h5',
            'e5e1', 'e5e2', 'e5e3', 'e5e4', 'e5e6', 'e5e7', 'e5e8'
          )
        end
      end
      
      context 'when rook can capture' do
        subject(:game) { described_class.new(fen: '8/8/4p3/3bRb2/4q3/8/8/8 w - a7 0 0') }
        
        it 'returns the correct noves' do
          capture_moves = game.moves_at('e5')
          expect(capture_moves).to contain_exactly('e5e4', 'e5e6', 'e5d5', 'e5f5')
        end
      end
      
      context 'when rook is blocked on all sides' do
        subject(:game) { described_class.new(fen: '8/8/4P3/3BRB2/4Q3/8/8/8 w - a7 0 0') }
        
        it 'returns no moves' do
          moves = game.moves_at('e5')
          expect(moves).to be_empty
        end
      end
    end
    
    describe 'moves for queen' do
      context 'when the piece is a queen' do
        subject(:game) { described_class.new(fen: '8/8/8/4Q3/8/8/8/8 w - a7 0 0') }
        
        it 'returns the correct noves' do
          moves = game.moves_at('e5')
          expect(moves).to contain_exactly(
            'e5f6', 'e5g7', 'e5h8', 'e5d6', 'e5c7', 'e5b8', 'e5f4', 'e5g3',
            'e5h2', 'e5d4', 'e5c3', 'e5b2', 'e5a1', 'e5a5', 'e5b5', 'e5c5',
            'e5d5', 'e5f5', 'e5g5', 'e5h5', 'e5e1', 'e5e2', 'e5e3', 'e5e4',
            'e5e6', 'e5e7', 'e5e8'
          )
        end
      end
      
      context 'when the queen can capture' do
        subject(:game) { described_class.new(fen: '8/8/3qpq2/3rQr2/3nnp2/8/8/8 w - a7 0 0') }
        
        it 'returns the correct noves' do
          capture_moves = game.moves_at('e5')
          expect(capture_moves).to contain_exactly(
            'e5f6', 'e5d6', 'e5d4', 'e5f4', 'e5e4', 'e5e6', 'e5d5', 'e5f5'
          )
        end
      end
      
      context 'when queen is blocked on all sides' do
        subject(:game) { described_class.new(fen: '8/8/3QBN2/3PQB2/3KPQ2/8/8/8 w - a7 0 0') }
        
        it 'returns no moves' do
          moves = game.moves_at('e5')
          expect(moves).to be_empty
        end
      end
    end
    
    describe 'moves for king' do
      context 'when the piece is a king' do
        subject(:game) { described_class.new(fen: '8/8/8/4K3/8/8/8/8 w - a7 0 0') }
        
        it 'returns the correct noves' do
          moves = game.moves_at('e5')
          expect(moves).to contain_exactly(
            'e5f6', 'e5d6', 'e5f4', 'e5d4', 'e5d5', 'e5f5', 'e5e6', 'e5e4'
          )
        end
      end
      
      context 'when king is blocked on all sides' do
        subject(:game) { described_class.new(fen: '8/8/3KBN2/3PQB2/3KPQ2/8/8/8 w - a7 0 0') }
        
        it 'returns no moves' do
          moves = game.moves_at('e5')
          expect(moves).to be_empty
        end
      end
      
      context 'when castling is possible' do
        subject(:game) { described_class.new(fen: '8/8/8/8/8/8/8/R3K2R w KQ - 0 0') }
        
        it 'returns castling moves included' do
          moves = game.moves_at('e1')
          expect(moves).to include('0-0', '0-0-0')
        end
      end
      
      context 'when there is no castling rights' do
        subject(:game) { described_class.new(fen: '8/8/8/8/8/8/8/R3K2R w kq - 0 0') }
        
        it 'returns castling moves included' do
          moves = game.moves_at('e1')
          expect(moves).not_to include('0-0', '0-0-0')
        end
      end
      
      context 'when there are pieces between the king and rooks' do
        subject(:game) { described_class.new(fen: '8/8/8/8/8/8/8/R1P1KB1R w KQ - 0 0') }
        
        it 'returns castling moves included' do
          moves = game.moves_at('e1')
          expect(moves).not_to include('0-0', '0-0-0')
        end
      end
    end
  end
end

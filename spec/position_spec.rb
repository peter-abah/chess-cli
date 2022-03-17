# frozen_string_literal: true

require_relative '../lib/rb_chess/position'

describe Position do
  subject(:position) { described_class.new(y: 0, x: 0) }

  describe '#y' do
    it 'should return the correct value' do
      expect(position.y).to eq 0
    end
  end
  
  describe '#x' do
    it 'should return the correct value' do
      expect(position.x).to eq 0
    end
  end
  
  describe '#to_s' do
    it 'should return the correct value' do
      expect(position.to_s).to eq 'a8'
    end
  end
  
  describe '#==' do
    it 'returns true if both positions have the same y and x values' do
      another_position = described_class.new(y: 0, x: 0)
      expect(position).to eq another_position
    end
    
    it 'returns false if both positions do not have the same y and x values' do
      another_position = described_class.new(y: 5, x: 4)
      expect(position).not_to eq another_position
    end
    
    it 'returns false if the argument is not a Position object' do
      expect(position).not_to eq 'a_string'
    end
  end
  
  describe '#square_type' do
    context 'when position is a1' do
      subject(:position) { described_class.parse('a1') }
      
      it { is_expected.to have_attributes(square_type: :dark) }
    end
    
    context 'when position is a8' do
      subject(:position) { described_class.parse('a8') }
      
      it { is_expected.to have_attributes(square_type: :light) }
    end
  end
  
  describe '#in_bounds?' do
    context 'when position coordinates are in board positions' do
      let(:position) { described_class.new(y: 0, x: 1) }
      
      it 'returns true' do
        expect(position).to be_in_bounds
      end
    end
    
    context 'when position coordinates are outside board positions' do
      let(:position) { described_class.new(y: 12, x: 9) }
      
      it 'returns false' do
        expect(position).not_to be_in_bounds
      end
    end
  end
  
  describe '#out_of_bounds?' do
    context 'when position coordinates are in board positions' do
      let(:position) { described_class.new(y: 0, x: 1) }
      
      it 'returns false' do
        expect(position).not_to be_out_of_bounds
      end
    end
    
    context 'when position coordinates are outside board positions' do
      let(:position) { described_class.new(y: 12, x: 9) }
      
      it 'returns true' do
        expect(position).to be_out_of_bounds
      end
    end
  end
  
  describe '#starting_pawn_rank?' do
    context 'when rank is 2 and color is white' do
      let(:position) { described_class.parse('a2') }
      
      it 'returns true' do
        expect(position).to be_starting_pawn_rank :white
      end
    end
    
    context 'when rank is 7 and color is black' do
      let(:position) { described_class.parse('a7') }
      
      it 'returns true' do
        expect(position).to be_starting_pawn_rank :black
      end
    end
    
    context 'when rank is 4 and color is white' do
      let(:position) { described_class.parse('a4') }
      
      it 'returns false' do
        expect(position).not_to be_starting_pawn_rank :white
      end
    end
  end
  
  describe '#en_passant_rank?' do
    context 'when rank is 4 and color is white' do
      let(:position) { described_class.parse('a4') }
      
      it 'returns true' do
        expect(position).to be_en_passant_rank :white
      end
    end
    
    context 'when rank is 5 and color is black' do
      let(:position) { described_class.parse('a5') }
      
      it 'returns true' do
        expect(position).to be_en_passant_rank :black
      end
    end
    
    context 'when rank is 7 and color is white' do
      let(:position) { described_class.parse('a7') }
      
      it 'returns false' do
        expect(position).not_to be_en_passant_rank :white
      end
    end
  end
  
  describe '#king_pos?' do
    context 'when pos is e1 and color is white' do
      let(:position) { described_class.parse('e1') }
      
      it 'returns true' do
        expect(position).to be_king_pos :white
      end
    end
    
    context 'when pos is e8 and color is black' do
      let(:position) { described_class.parse('e8') }
      
      it 'returns true' do
        expect(position).to be_king_pos :black
      end
    end
    
    context 'when pos is a4 and color is white' do
      let(:position) { described_class.parse('a4') }
      
      it 'returns false' do
        expect(position).not_to be_king_pos :white
      end
    end
  end
  
  describe '#kingside_rook_pos?' do
    context 'when pos is h1 and color is white' do
      let(:position) { described_class.parse('h1') }
      
      it 'returns true' do
        expect(position).to be_kingside_rook_pos :white
      end
    end
    
    context 'when pos is h8 and color is black' do
      let(:position) { described_class.parse('h8') }
      
      it 'returns true' do
        expect(position).to be_kingside_rook_pos :black
      end
    end
    
    context 'when pos is a4 and color is white' do
      let(:position) { described_class.parse('a4') }
      
      it 'returns false' do
        expect(position).not_to be_kingside_rook_pos :white
      end
    end
  end
  
  describe '#queenside_rook_pos?' do
    context 'when pos is a1 and color is white' do
      let(:position) { described_class.parse('a1') }
      
      it 'returns true' do
        expect(position).to be_queenside_rook_pos :white
      end
    end
    
    context 'when pos is a8 and color is black' do
      let(:position) { described_class.parse('a8') }
      
      it 'returns true' do
        expect(position).to be_queenside_rook_pos :black
      end
    end
    
    context 'when pos is a4 and color is white' do
      let(:position) { described_class.parse('a4') }
      
      it 'returns false' do
        expect(position).not_to be_queenside_rook_pos :white
      end
    end
  end
  
  describe '#increment' do
    context 'when passed y and x values' do
      it 'returns a new position that is incremented by the value' do
        new_position = position.increment(y: 1, x: 1)
        expect(new_position).to have_attributes(y: 1, x: 1)
      end
      
      it 'increases only y if it is the only argument' do
        new_position = position.increment(y: 1)
        expect(new_position).to have_attributes(y: 1, x: 0)
      end
      
      it 'does not change anything if no argument is passed' do
        new_position = position.increment
        expect(new_position).to have_attributes(y: 0, x: 0)
      end
    end
  end
  
  describe '::parse' do
    context 'when passed an algebraic notation for chess position i.e b5 or h7' do
      it 'returns the correct position for a1' do
        position = Position.parse('a1')
        expect(position).to have_attributes(y: 7, x: 0)
      end
      
      it 'returns the correct position for h8' do
        position = Position.parse('h8')
        expect(position).to have_attributes(y: 0, x: 7)
      end
      
      it 'raises an error for invalid position' do
        expect { Position.parse('i0') }.to raise_error ChessError
      end
    end
  end
end
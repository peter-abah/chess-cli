# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#initilize' do
    context 'when called with no argument' do
      subject(:board) { described_class.new }

      matcher :have_pawns_at_default_positions do |color|
        match do |board|
          y = color == 'white' ? 6 : 1
          pawns = (0..7).map { |x| board.piece_at(y: y, x: x) }
          pawns.all? { |pawn| pawn.color == color && pawn.is_a?(Pawn) }
        end
      end

      matcher :have_knights_at_default_positions do |color|
        match do |board|
          y = color == 'white' ? 7 : 0
          knights = [1, 6].map { |x| board.piece_at(y: y, x: x) }
          knights.all? { |knight| knight.color == color && knight.is_a?(Knight) }
        end
      end

      matcher :have_knights_at_default_positions do |color|
        match do |board|
          y = color == 'white' ? 7 : 0
          knights = [1, 6].map { |x| board.piece_at(y: y, x: x) }
          knights.all? { |knight| knight.color == color && knight.is_a?(Knight) }
        end
      end

      matcher :have_rooks_at_default_positions do |color|
        match do |board|
          y = color == 'white' ? 7 : 0
          rooks = [0, 7].map { |x| board.piece_at(y: y, x: x) }
          rooks.all? { |rook| rook.color == color && rook.is_a?(Rook) }
        end
      end

      matcher :have_bishops_at_default_positions do |color|
        match do |board|
          y = color == 'white' ? 7 : 0
          bishops = [2, 5].map { |x| board.piece_at(y: y, x: x) }
          bishops.all? { |bishop| bishop.color == color && bishop.is_a?(Bishop) }
        end
      end

      matcher :have_king_at_default_position do |color|
        match do |board|
          y = color == 'white' ? 7 : 0
          x = 4
          king = board.piece_at(y: y, x: x)
          king.color == color && king.is_a?(King)
        end
      end

      matcher :have_queen_at_default_position do |color|
        match do |board|
          y = color == 'white' ? 7 : 0
          x = 3
          queen = board.piece_at(y: y, x: x)
          queen.color == color && queen.is_a?(Queen)
        end
      end

      it 'creates a new board with pawns at default positions' do
        expect(board).to have_pawns_at_default_positions 'white'
        expect(board).to have_pawns_at_default_positions 'black'
      end

      it 'creates a new board with knights at default positions' do
        expect(board).to have_knights_at_default_positions 'white'
        expect(board).to have_knights_at_default_positions 'black'
      end

      it 'creates a new board with rooks at default positions' do
        expect(board).to have_rooks_at_default_positions 'white'
        expect(board).to have_rooks_at_default_positions 'black'
      end

      it 'creates a new board with bishops at default positions' do
        expect(board).to have_bishops_at_default_positions 'white'
        expect(board).to have_bishops_at_default_positions 'black'
      end

      it 'creates a new board with kings at default positions' do
        expect(board).to have_king_at_default_position 'white'
        expect(board).to have_king_at_default_position 'black'
      end

      it 'creates a new board with queens at default positions' do
        expect(board).to have_queen_at_default_position 'white'
        expect(board).to have_queen_at_default_position 'black'
      end
    end

    context 'when called with a fen notation' do
      let(:fen_notation) { 'P7/4r3/8/8/6k1/8/8/8' }
      subject(:board) { described_class.new(fen_notation: fen_notation) }

      it 'creates a new board corresponding to the fen notation' do
        white_pawn = board.piece_at(y: 0, x: 0)
        expect(white_pawn).to be_a(Pawn).and have_attributes(color: 'white')
      end

      it 'creates a new board corresponding to the fen notation' do
        black_rook = board.piece_at(y: 1, x: 4)
        expect(black_rook).to be_a(Rook).and have_attributes(color: 'black')
      end

      it 'creates a new board corresponding to the fen notation' do
        black_king = board.piece_at(y: 4, x: 6)
        expect(black_king).to be_a(King).and have_attributes(color: 'black')
      end
    end
  end

  describe '#piece_at' do
    subject(:board) { described_class.new }

    context 'when called with y and x' do
      it 'should return a piece' do
        piece = board.piece_at(y: 0, x: 0)
        expect(piece).to be_a Piece
      end

      it 'should return the correct piece at y and x position' do
        piece = board.piece_at(y: 0, x: 0)
        expect(piece).to be_a Rook
      end
    end
  end

  describe '#update' do
    subject(:board) { described_class.new }

    context 'when called with a move to move a pawn' do
      it 'returns a new board updated with the move' do
        move = double(moved: { [1, 3] => [3, 3] }, removed: nil, promotion: false)
        piece = board.update(move).piece_at(y: 3, x: 3)
        expect(piece).to be_a Pawn
      end

      # TODO: Make it test prev_state
      it 'returns a new board with @prev_board_array as the board board_array' do
        board_array = board.instance_variable_get(:@board_array)
        move = double(moved: { [1, 3] => [3, 3] }, removed: nil, promotion: false)

        prev_board_array = board.update(move).instance_variable_get(:@prev_board_array)
        expect(prev_board_array).to eq(board_array)
      end
    end

    context 'when called with a move to move a knight' do
      it 'returns a new board updated with the move' do
        move = double(moved: { [0, 1] => [2, 0] }, removed: nil, promotion: false)
        piece = board.update(move).piece_at(y: 2, x: 0)
        expect(piece).to be_a Knight
      end
    end

    context 'when called with a move to remove a piece' do
      it 'returns a new board updated with the board' do
        move = double(moved: { [0, 1] => [2, 0] }, removed: [7, 5], promotion: false)
        piece = board.update(move).piece_at(y: 7, x: 5)
        expect(piece).to be_nil
      end
    end

    context 'when called with a move that promotes a pawn' do
      it 'returns a new board with the piece being promoted' do
        move = double(moved: { [1, 1] => [2, 1] }, removed: nil, promotion: Queen)

        piece = board.update(move).piece_at(y: 2, x: 1)
        expect(piece).to be_a Queen
      end
    end
  end
end

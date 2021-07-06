# frozen_string_literal: true

require_relative '../lib/game_func'
require_relative '../lib/board'
require_relative '../lib/move'

describe GameFunc do
  let(:dummy_class) { Class.new { extend GameFunc } }
  let(:board_array) { Board.new.board_array }

  describe '#legal_move?' do
    context 'when given a legal move' do
      it 'returns true' do
        move = Move.new([6, 3], [5, 3])
        player = double(color: 'white')
        board = Board.new

        result = dummy_class.legal_move?(move, player, board)
        expect(result).to be true
      end
    end

    context 'when given an illegal move' do
      it 'returns false' do
        board_array[2][4] = board_array[0][3]
        board_array[0][3] = nil
        board = Board.new(board_array)

        move = Move.new([7, 4], [5, 4])
        player = double(color: 'white')

        result = dummy_class.legal_move?(move, player, board)
        expect(result).to be false
      end
    end
  end

  describe '#check?' do
    context 'when called for white player with a starting board' do
      it 'returns false' do
        board = Board.new
        player = double(color: 'white')
        result = dummy_class.check?(player, board)
        expect(result).to be false
      end
    end

    context 'when called for black player with a starting board' do
      it 'returns false' do
        board = Board.new
        player = double(color: 'black')
        result = dummy_class.check?(player, board)
        expect(result).to be false
      end
    end

    context 'when called for white player in check' do
      it 'returns true' do
        # arrange the board so the black queen is attacking the white king
        board_array[2][4] = board_array[0][3]
        board_array[6][4] = nil
        board_array[0][3] = nil

        board = Board.new(board_array)
        player = double(color: 'white')
        result = dummy_class.check?(player, board)
        expect(result).to be true
      end
    end

    context 'when called for black with white in check' do
      it 'returns false' do
        # arrange the board so the black queen is attacking the white king
        board_array[2][4] = board_array[0][3]
        board_array[6][4] = nil
        board_array[0][3] = nil

        board = Board.new(board_array)
        player = double(color: 'black')
        result = dummy_class.check?(player, board)
        expect(result).to be false
      end
    end

    context 'when called for black with black in check' do
      it 'returns true' do
        # arrange the board so the white queen is attacking the black king
        board_array[5][4] = board_array[7][3]
        board_array[1][4] = nil
        board_array[7][3] = nil

        board = Board.new(board_array)
        player = double(color: 'black')
        result = dummy_class.check?(player, board)
        expect(result).to be true
      end
    end

    context 'when called for white with black in check' do
      it 'returns false' do
        # arrange the board so the white queen is attacking the black king
        board_array[5][4] = board_array[7][3]
        board_array[1][4] = nil
        board_array[7][3] = nil

        board = Board.new(board_array)
        player = double(color: 'white')
        result = dummy_class.check?(player, board)
        expect(result).to be false
      end
    end
  end
end

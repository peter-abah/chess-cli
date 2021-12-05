# frozen_string_literal: true

require 'pp'
require 'fakefs/spec_helpers'
require_relative '../lib/serializer'

describe Serializer do
  include FakeFS::SpecHelpers

  describe '#saved_games' do
    context 'when there is no saved_games directory' do
      it 'returns an empty array' do
        expect(described_class.saved_games).to be_empty
      end
    end

    context 'when there is an empty saved_games directory' do
      before do
        Dir.mkdir('saved_games')
      end

      it 'returns an empty array' do
        expect(described_class.saved_games).to be_empty
      end
    end

    context 'when there is a saved_games with files in it' do
      before do
        Dir.mkdir('saved_games')
        File.open('saved_games/test1', 'w') {}
        File.open('saved_games/test2', 'w') {}
      end

      it 'returns an array of the file names' do
        files = described_class.saved_games
        expected = %w[saved_games/test1 saved_games/test2]
        expect(files).to eq(expected)
      end
    end
  end

  describe '#save_game' do
    context 'when called with a game state' do
      before :each do
        allow(described_class).to receive(:gets).and_return('test1')
        allow(described_class).to receive(:puts)
      end

      it 'saves the game_state in a specified file name' do
        game_state = {}
        expected_file = 'saved_games/test1.yaml'
        described_class.save_game(game_state)
        expect(File.file?(expected_file)).to be true
      end
    end
  end
end

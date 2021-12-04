# frozen_string_literal: true

require 'fakefs/spec_helpers'
require_relative './lib/serializer'

describe Serializer do
  # Creating dummy class that extends serializer module so
  # the methods can be tested
  let(:dummy_class) { Class.new { extend Serializer } }

  describe '#saved_games' do
    include FakeFS::SpecHelpers

    context 'when there is no saved_games directory' do
      it 'returns an empty array' do
        expect(dummy_class.saved_games).to be_empty
      end
    end

    context 'when there is an empty saved_games directory' do
      before do
        Dir.mkdir('saved_games')
      end

      it 'returns an empty array' do
        expect(dummy_class.saved_games).to be_empty
      end
    end

    context 'when there is a saved_games with files in it' do
      before do
        Dir.mkdir('saved_games')
        File.open('test1', 'w') {}
        File.open('test2', 'w') {}
      end

      it 'returns an array of the file names' do
        files = dummy_class.saved_games
        expected = %w[saved_games/test1 saved_games/test2]
        expect(files).to eq(expected)
      end
    end
  end
end

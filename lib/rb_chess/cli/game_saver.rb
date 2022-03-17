# frozen_string_literal: true

require 'fileutils'

module RbChess
  class GameSaver
    def initialize
      Dir.exist?(dirname) || FileUtils.mkdir_p(dirname)
    end

    def saved_games
      files = Dir.entries(dirname).reject { |f| ['.', '..'].include?(f) }
    end

    def save(game, players, filename)
      filename = File.join(dirname, filename)
      data = Marshal.dump([game, players])
      File.open(filename, 'wb') { |f| f.write(data) }
      puts 'Game saved'
    end

    def load(filename)
      filename = File.join(dirname, filename)
      data = File.open(filename, 'rb') { |f| f.read }

      Marshal.load(data)
    end

    def dirname
      File.join(Dir.home, '.rb_chess/saved')
    end
  end
end

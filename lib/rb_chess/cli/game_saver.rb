# frozen_string_literal: true

require 'fileutils'

class GameSaver
  def initialize
    Dir.exist?(dirname) || FileUtils.mkdir_p(dirname)
  end

  def saved_games
    files = Dir.entries(dirname).reject { |f| f == '.' || f == '..'}
  end

  def save(game, players, filename)
    filename = File.join(dirname, filename)
    data = Marshal.dump([game, players])
    File.open(filename, 'w') { |f| f.write(data) }
    puts 'Game saved'
  end

  def load(filename)
    filename = File.join(dirname, filename)
    data = File.read(filename)

    Marshal.load(data)
  end

  def dirname
    File.join(Dir.home, '.rb_chess/saved')
  end
end
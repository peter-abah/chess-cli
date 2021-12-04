# frozen_string_literal: true

# A module to save and load game state to file system
module Serializer
  SAVED_GAMES_PATH = 'saved_games'

  def saved_games
    return [] unless Dir.exist?(SAVED_GAMES_PATH)

    files = Dir.entries(SAVED_GAMES_PATH).drop(2)
    files.map { |file| "#{SAVED_GAMES_PATH}/#{file}" }
  end
end

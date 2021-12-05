# frozen_string_literal: true

require 'yaml'
require_relative './prompts'

# A module to save and load game state to file system
module Serializer
  SAVED_GAMES_PATH = 'saved_games'

  def self.saved_games
    return [] unless Dir.exist?(SAVED_GAMES_PATH)

    files = Dir.entries(SAVED_GAMES_PATH).drop(2)
    files.map { |file| "#{SAVED_GAMES_PATH}/#{file}" }
  end

  def self.save_game(game_state)
    file_name = prompt_file_name
    File.open(file_name, 'w') { |file| file.write(game_state.to_yaml) }
  end

  def self.prompt_file_name
    puts Prompts.file_name
    file_name = ''
    loop do
      file_name = gets.chomp
      break unless file_name.empty?

      puts invalid_file_name_prompt
    end

    Dir.mkdir(SAVED_GAMES_PATH) unless Dir.exist?(SAVED_GAMES_PATH)
    file_name = "#{SAVED_GAMES_PATH}/#{file_name}.yaml"
  end
end

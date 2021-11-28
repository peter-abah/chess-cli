# frozen_string_literal: true

require 'yaml'

require_relative 'game'
require_relative 'player'
require_relative 'computer_player'

def main
  display_tutorial
  option = start_game_options
  start_game(option)
end

def display_tutorial
  puts <<-HEREDOC

  Welcome to Chess.

  Players take turns by choosing pieces

  Pieces are chosen by selecting the square they are on e.g a2, d7

  If the piece has legal moves available, the game will display them or the the
  player must choose another piece.

  A player can enter [save] at any time to save the game.

  If a player is in check, they can only select pieces with moves that take them
  out of check.

  Enjoy the game.
  HEREDOC
end

def start_game_options
  display_game_options
  ask_game_option
end

def display_game_options
  puts <<-HEREDOC
  ---------------------
  1 - New game
  2 - Load saved game
  HEREDOC
end

def ask_game_option
  loop do
    option = gets.chomp.to_i
    return option if option.between?(1, 2)
  end
end

def start_game(option)
  game = option == 1 ? new_game : load_game
  return if game.nil?

  game.play
end

def new_game
  players = get_players
  Game.new(*players)
end

def load_game
  if Dir.exist?('saved_games') || Dir.entries('saved_game').length.zero?
    file_names = Dir.entries('saved_games')
    display_file_names(file_names)

    option = get_file_option(file_names.length)
    saved_game = File.read("saved_games/#{file_names[option]}")

    YAML.load(saved_game)
  else
    puts 'Saved game does not exist'
  end
end

def display_file_names(file_names)
  puts '-------------------'
  file_names.each_with_index do |file_name, i|
    puts "#{i + 1} - #{file_name}"
  end
end

def get_file_option(length)
  loop do
    option = gets.chomp.to_i - 1
    return option if option.between?(0, length)
  end
end

def get_players
  white = get_player_choice('white')
  black = get_player_choice('black')

  [white, black]
end

def get_player_choice(color)
  puts "Choose #{color} player"
  display_players_choice
  choice = gets.chomp.to_i

  choice == 1 ? Player.new(color) : ComputerPlayer.new(color)
end

def display_players_choice
  puts <<-HEREDOC
  -------------
  1 - Human
  2 - Computer (very easy)
  HEREDOC
end

main

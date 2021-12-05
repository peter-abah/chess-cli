# frozen_string_literal: true

require 'rocketman'
require_relative './game'
require_relative './prompts'
require_relative './serializer'
require_relative './display'
require_rel './players'

# Class for interface to play chess on the console
class ConsoleUI
  include Rocketman::Producer
  extend Rocketman::Consumer
  PLAYER_COLORS = %w[white black].freeze

  def initialize
    puts Prompts.welcome

    game_state = init_game
    @game = game_state[:state]
    @players = game_state[:players]
    @current_player = game_state[:current_player]
    @game.start
  end

  def init_game
    game_option = get_game_option
    case game_option
    when 1
      new_game
    when 2
      load_game
    end
  end

  def new_game
    game = Game.new
    players = init_players
    current_player = init_players[:white]
    { game: game, players: players, current_player: current_player }
  end

  def init_players
    PLAYER_COLORS.reduce({}) do |players, color|
      players[color.to_sym] = player_type(color)
    end
  end

  def player_type(color)
    choice = nil
    loop do
      puts Prompts.player_type(color)
      choice = gets.chomp.to_i
      break if [1, 2].include?(choice)
    end
    choice == 1 ? Player.new(color) : ComputerPlayer.new(color)
  end

  def load_game
    saved_games = Serializer.saved_games

    if saved_games.empty?
      puts Prompts.no_saved_games
      return
    end

    saved_game = saved_games_choice(saved_games)
    Serialize.load_game(saved_game)
  end

  def saved_game_choice(saved_games)
    choice = -1
    until choice.between?(0, saved_games.length)
      puts Prompts.saved_games_choice(saved_games)
      choice = gets.chomp.to_i
    end
    saved_games[choice - 1]
  end

  def display_board(board)
    puts Display.board_representation(board)
  end

  def player_move(payload)
    player = @players[payload.color.to_sym]
    move = player.is_a? ComputerPlayer ? player.move : prompt_move
    # emit move to game
  end

  def end_game(payload)
  end

  on_event(:board) { |payload| display_board(payload[:board]) }
  on_event(:get_move) { |payload| player_move(payload) }
  on_event(:game_end) { |payload| end_game(payload) }
end

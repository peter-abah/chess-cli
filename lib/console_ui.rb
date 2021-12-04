# frozen_string_literal: true

require 'rocketman'
require_relative './game'

# Class for interface to play chess on the console
class ConsoleUI
  include Rocketman::Producer
  extend Rocketman::Consumer

  def initialize
    @game, @players = init_game
    @game.start
  end

  def init_game
    # Display instructions
    # Get player option for new game or to load game
    # If new game create new game and load players
    # else load saved game and return
  end

  def display_board(board)
  end

  def player_move(payload)
  end

  def end_game(payload)
  end

  on_event(:board) { |payload| display_board(payload[:board]) }
  on_event(:get_move) { |payload| player_move(payload) }
  on_event(:game_end) { |payload| end_game(payload) }
end

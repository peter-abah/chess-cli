# frozen_string_literal: true

# A module for game prompts
module Prompts
  def welcome_prompt
    <<~HEREDOC

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

  def game_choice_prompt
    <<~HEREDOC
      ---------------------
      1 - New game
      2 - Load saved game
    HEREDOC
  end

  def player_type_prompt(color)
    <<~HEREDOC
      Choose #{color} player
      -------------
      1 - Human
      2 - Computer (very easy)
    HEREDOC
  end

  def piece_pos_prompt(color)
    "#{color} enter a position to move (e4 or c7)"
  end

  def move_choice_prompt
    'Choose a move (e.g 1 or 2)'
  end

  def file_name_prompt
    <<~HEREDOC
      Enter the name you want to save your game as.
      Entering a name you have used to save a previous game state will overwrite that game state
    HEREDOC
  end

  def invalid_file_name_prompt
    'Name invalid. Note that name must not be empty'
  end
end

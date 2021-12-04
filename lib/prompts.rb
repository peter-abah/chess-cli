# frozen_string_literal: true

# A module for game prompts
module Prompts
  def welcome
    <<-HEREDOC

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

  def game_choice
    <<-HEREDOC
    ---------------------
    1 - New game
    2 - Load saved game
    HEREDOC
  end

  def player_type(color)
    <<-HEREDOC
    Choose #{color} player
    -------------
    1 - Human
    2 - Computer (very easy)
    HEREDOC
  end

  def piece_pos_choice(color)
    "#{color} enter a position to move (e4 or c7)"
  end

  def move_choice
    'Choose a move (e.g 1 or 2)'
  end
end
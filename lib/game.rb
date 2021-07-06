# frozen_string_literal: true

require 'yaml'
require_relative 'board'
require_relative 'game_func'

# A class to handle a chess game
class Game
  include GameFunc

  def initialize(black, white)
    @black = black
    @white = white
    @current_player = white

    @board = Board.new
  end

  def play
    game_turns until game_end?
    display_end_game_message
  end

  def game_turns
    board.display
    move = player_move(@current_player)
    board = board.update(move)
    @current_player = @current_player == white ? black : white
  end

  def player_move(player)
    player.is_a?(HumanPlayer) ? get_player_move(player) : player.play_move
  end

  def get_player_move(player)
    loop do
      puts "#{player.color} enter position of piece to move (e4 or c7)"
      pos = gets.chomp.downcase
      break if valid_choice?(pos, player.color)

      save_game if pos == 'save'
    end

    moves = get_all_moves(pos)

    loop do
      diplay_moves(moves)
      puts 'Choose a move (e.g 1)'
      input = gets.chomp.to_i
      break if input.between?(1, moves.length)
    end

    moves[input]
  end

  def valid_choice?(pos, color)
    y = pos[0].ord - 96
    x = pos[1].to_i - 1
    return false unless y.between?(0, 7) && x.between?(0, 7)

    piece = board.board_array[y][x]
    return false unless piece&.color == color

    piece.possible_moves(board, [y, x]).length.positive?
  end

  def save_game
    saved_game = to_yaml
    file_name = "#{Time.now.to_s[0..-7].gsub(' ', '_')}.yaml"

    File.open(file_name, 'w') do |file|
      file.write(saved_game)
    end

    puts "game saved as #{file_name}"
  end

  def get_all_moves(pos)
    y = pos[0].ord - 96
    x = pos[1].to_i - 1

    piece = board.board_array[y][x]
    piece.possible_moves(board, [y, x])
  end

  def display_moves(moves)
    moves.each_with_index do |move, i|
      puts "#{i + 1}. #{move}"
    end
  end
end

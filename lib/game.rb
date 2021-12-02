# frozen_string_literal: true

require 'yaml'

require_relative 'board'
require_relative 'game_func'

# A class to handle a chess game
class Game
  include GameFunc

  attr_accessor :winner
  attr_reader :player, :board, :black, :white, :player_check, :castling_possible

  def initialize(white, black)
    @black = black
    @white = white
    @player = white

    @board = Board.new
    @player_check = { 'black' => false, 'white' => false }
    @castling_possible = {
      black: { queenside: true, kingside: true },
      white: { queenside: true, kingside: true }
    }
    @winner = nil
  end

  def play
    game_turns until game_end?
    display_end_game_message
  end

  def game_end?
    player_check[player.color] = false

    check = check?(player, board)
    stalemate = legal_moves(board, player).empty?

    if stalemate && check
      @winner = player == white ? black : white
      return true
    end

    return true if stalemate

    player_check[player.color] = check
    false
  end

  def game_turns
    board.display
    move = player_move
    @board = board.update(move)
    @player = @player == white ? black : white
  end

  def display_end_game_message
    board.display
    if @winner
      puts "#{@winner.color} won this round, checkmate"
    else
      puts 'A stalemate, better luck to both sides next time'
    end
  end

  def player_move
    player.is_a?(ComputerPlayer) ? player.play_move(board) : prompt_player_move
  end

  def prompt_player_move
    pos = prompt_for_piece_pos
    moves = get_all_moves(pos)

    input = prompt_for_move_choice(moves)
    move = moves[input]

    move.promotion = prompt_promotion_choice if move.promotion
    move
  end

  def prompt_for_piece_pos
    pos = nil

    loop do
      puts "#{player.color} enter position of piece to move (e4 or c7)"
      pos = gets.chomp.downcase
      break if valid_choice?(pos, player.color)

      save_game if pos == 'save'
    end
    pos
  end

  def prompt_for_move_choice(moves)
    input = nil

    loop do
      display_moves(moves)
      puts 'Choose a move (e.g 1)'
      input = gets.chomp.to_i - 1
      break if input.between?(0, moves.length - 1)
    end
    input
  end

  def prompt_promotion_choice
    puts '1. Queen | 2. Rook | 3. Bishop | 4. Knight | 5. Pawn'
    puts 'Enter an option (e.g 1 or 3)'
    choice = gets.to_i

    PROMOTION_CHOICES[choice]
  end

  def valid_choice?(pos, color)
    return false if pos.length < 2

    x = pos[0].ord - 97
    y = 8 - pos[1].to_i

    return false unless y.between?(0, 7) && x.between?(0, 7)

    piece = board.piece_at(y: y, x: x)
    return false unless piece&.color == color

    moves = piece.possible_moves(board, [y, x]).select { |move| legal_move?(move, player, board) }
    moves.length.positive?
  end

  def save_game
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

    saved_game = YAML.dump(self)

    file_name = "saved_games/#{Time.now.to_s[0..-7].gsub(' ', '_')}.yaml"
    file_name = file_name.gsub(':', "'")

    File.open(file_name, 'w') do |file|
      file.write(saved_game)
    end

    puts "game saved as #{file_name}"
  end

  def get_all_moves(pos)
    x = pos[0].ord - 97
    y = 8 - pos[1].to_i

    piece = board.piece_at(y: y, x: x)
    piece.possible_moves(board, [y, x]).select { |move| legal_move?(move, player, board) }
  end

  def display_moves(moves)
    moves.each_with_index do |move, i|
      puts "#{i + 1}. #{move}"
    end
  end
end

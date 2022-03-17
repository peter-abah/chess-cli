# frozen_string_literal: true

require 'require_all'

require_relative '../game'
require_rel '.'

module RbChess
  class CLI
    def initialize
      @game_saver = GameSaver.new
    end

    def start
      welcome
      @game, @players = game_option == :new ? new_game : load_game
      play_game
    end

    def welcome
      puts 'Welcome to Chess.'
      help
      puts 'Enjoy the game.'
    end

    def game_option
      choice = -1
      until choice.between?(1, 2)
        puts <<~HEREDOC
          ---------------------
          1 - New game
          2 - Load saved game
        HEREDOC

        choice = gets.chomp.to_i
      end

      choice == 1 ? :new : :load
    end

    def new_game
      players = get_players
      [Game.new, players]
    end

    def load_game
      files = @game_saver.saved_games
      if files.empty?
        puts 'No Games to load. Starting new game'
        return new_game
      end

      choice = -1
      until choice.between?(0, files.size - 1)
        display_list(files)
        puts 'Choose game to load. (Enter number)'
        choice = gets.chomp.to_i - 1
      end

      @game_saver.load(files[choice])
    end

    def play_game
      game_loop until @game.game_over?

      puts @game.board.ascii
      puts end_game_msg
      play_again? && start
    end

    def game_loop
      puts @game.board.ascii
      puts "#{player.name} in check!" if @game.check?
      input = player_input

      if commands[input.to_sym]
        commands[input.to_sym].call
      elsif pos? input
        show_pos_moves input
      elsif @game.valid_move? input
        @game.make_move input
      else
        puts 'Invalid move or command!'
      end
    end

    def player
      @players.find { |p| p.color == @game.current_player }
    end

    def end_game_msg
      player = @players.find { |p| p.color == @game.winner }

      if @game.checkmate?
        "Checkmate #{player.name} wins!"
      elsif @game.stalemate?
        'Draw by stalemate!'
      elsif @game.fivefold?
        'Draw by fivefold repetition!'
      elsif @game.seventy_five_moves?
        'Draw by seventy five moves rule (No pawn move or capture in last seventy five moves)'
      elsif @game.insufficient_material?
        'Draw by insufficient material'
      else
        'Game over!'
      end
    end

    def play_again?
      p 'Do you want to play again?(Y|N default is N): '
      choice = gets.chomp.downcase
      choice == 'y'
    end

    def player_input
      return player.move(@game) if player.is_a? ComputerPlayer

      puts "#{player.name} Enter move"
      gets.chomp.downcase
    end

    def help
      puts <<~HEREDOC
        Moves are in coordinate system format e.g e2e4 with exception of castling moves
        which are 0-0 for kingside and 0-0-0 for queenside.

        You can also enter a piece position e.g b1.
        If the piece has legal moves available, the game will display them or the the
        player must choose another piece.

        For promotion moves append the promotion piece (Q, R, B, N) after the move
        e.g a2a1R

        If a player is in check, they can only select pieces with moves that take them
        out of check.

        Enter [moves] or [m] to view all available moves.

        Enter [save] or [s] at any time to save the game.

        Enter [exit] at any time to end the game

        Enter [help] or [h] to view this guide again

        The game ends by checkmate or draw (stalemate, fivefold repetition,
        insufficient material or seventy five turns without a capture or pawn move)
      HEREDOC
    end

    def moves
      display_list(@game.all_moves)
    end

    def save
      filename = ''
      while filename.empty?
        puts 'Enter filename: '
        filename = gets.chomp
      end

      @game_saver.save(@game, @players, filename)
    end

    def get_players
      mode = get_mode
      return [Player.new(:white), Player.new(:black)] if mode == :human

      color = get_color
      computer_color = color == :white ? :black : :white
      [Player.new(color), RandomAI.new(computer_color)]
    end

    def get_mode
      choice = -1
      until choice.between?(1, 2)
        puts <<~HEREDOC
          -------------
          Choose mode
          -------------
          1 - vs Human
          2 - vs Computer (just random moves)
        HEREDOC
        choice = gets.chomp.to_i
      end

      choice == 1 ? :human : :computer
    end

    def get_color
      choice = -1
      until choice.between?(1, 2)
        puts <<~HEREDOC
          -------------
          Choose color
          -------------
          1 - White
          2 - Black
        HEREDOC
        choice = gets.chomp.to_i
      end

      choice == 1 ? :white : :black
    end

    def commands
      @commands ||= {
        help: method(:help),
        h: method(:help),
        moves: method(:moves),
        m: method(:moves),
        exit: method(:exit),
        save: method(:save),
        s: method(:save)
      }
    end

    def pos?(pos)
      /^[a-h][1-8]$/.match pos
    end

    def show_pos_moves(pos)
      moves = @game.moves_at pos
      if moves.empty?
        puts "No moves at #{pos}"
        return
      end

      display_list(moves)
    end

    def display_list(list)
      list.each_with_index do |data, i|
        puts "#{i + 1} - #{data}"
      end
    end
  end
end

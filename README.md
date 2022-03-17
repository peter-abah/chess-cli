# rb_chess
A chess library written in ruby. It provides all a representation of a chess game with all rules and serialization. It also provides a command line interface for playing the game

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'just_chess'
```

And then run:
```
$ bundle
```

Or install it yourself as:
```
$ gem install rb_chess
```

## Features
- Supports all chess moves including:
  + En passant.
  + Castling.
  + Pawn promotion.
- The game detects and declares:
  + Checkmate.
  + Stalemate.
  + Insufficient material.
  + Fivefold repetition
  + Seventy five moves rule
- Move generation.
- Move validation.
- Serializing (json and binary).

## Usage

The code below plays a random game of chess:

```ruby
require 'rb_chess'

game = RbChess::Game.new

until game.game_over?
  puts game.board.ascii
  game.make_move(game.all_moves.sample)
end

puts game.board.to_fen
```

You can find the full example of using this library in the [RbChess::CLI](lib/rb_chess/cli/cli.rb) class in lib/rb_chess/cli/cli.rb.

## Playing
- To start run ``` rb_chess ```.
- Moves are made by typing in coordinate system i.e `e2e4`.
- Castling moves are made by typing `0-0` for kingside and `0-0-0` for queenside.
- Promotion moves are made by typing the move with the promotion piece after it e.g `a7a8Q`.
- To save type `save` or `s`.
- To quit the game type `exit`.

## To do
- Support for PGN.
- Support for SAN move format.

## License
Distributed under the MIT License. See LICENSE for more information.
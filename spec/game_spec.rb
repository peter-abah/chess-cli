# frozen_string_literal: true

require 'require_all'

require_relative '../lib/game'
require_rel './game_modules'

describe Game do
  it_behaves_like 'move generator'
end
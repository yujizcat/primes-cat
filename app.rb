require_relative "router"
require_relative "player_model"

players = []
players << Player.new("Player", 1)
players << Player.new("Rival1", 2)
players << Player.new("Rival2", 3)
start_game = Router.new(players, [2, 100], 3)
start_game.run

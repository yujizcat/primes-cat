require_relative "router"
require_relative "player_model"

players = []
players << Player.new("Player", 1, true)
players << Player.new("Rival1", 2, true)

start_game = Router.new(players, [2, 100], 8)
start_game.run

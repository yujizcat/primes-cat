require_relative "router"
require_relative "player_model"

players = []
players << Player.new("Player", 1, false)
players << Player.new("Rival1", 2, true)

start_game = Router.new(players, [2, 50], 3)
start_game.run

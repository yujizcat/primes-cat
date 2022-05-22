require_relative "router"
require_relative "player_model"

players = []
players << Player.new("Player", 1, true, 3)
players << Player.new("Rival1", 2, true, 10)

start_game = Router.new(players, [2, 100])
start_game.run

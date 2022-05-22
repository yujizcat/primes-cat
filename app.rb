require_relative "router"
require_relative "player_model"

players = []
players << Player.new("Player", true, 13)
# players << Player.new("Rival1", true, 8)

start_game = Router.new(players)
start_game.run

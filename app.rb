require_relative "router"
require_relative "player_model"

players = []
players << Player.new("Player", true)
# players << Player.new("Rival1", true)

start_game = Router.new(players)
start_game.run

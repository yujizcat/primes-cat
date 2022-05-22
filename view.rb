class PrimesView
  def initialize(game)
    @game = game
  end

  def display_top
    puts "             #{@game.get_model}"
    puts ""
    puts "---------------Round #{@game.get_current_round}---------------"
    puts ""
  end

  def display_bottom
    puts ""
    puts "----------#{@game.get_current_player.get_name}    ID #{@game.get_current_player.get_id}----------"
    puts ""
  end

  def display_space
    puts ""
    puts ""
    puts ""
    puts ""
    puts ""
  end

  def display_cards(player)
    if player == "me"
      cards = @game.get_current_player.get_cards
      card_space = 14
      puts "  "
      puts "Powers: #{@game.get_current_player.get_powers}"
      print "Average: <#{@game.get_current_player.get_cards_average}>"
      puts ""
      print "-" * card_space * cards.size
      puts ""
      print "  |     "
      cards.each do |card|
        print "#{card}    |    "
      end
      puts ""
      print "-" * card_space * cards.size
    else
      cards = @game.get_next_player.get_cards
      card_space = 6
      puts ""
      print "| "
      cards.each do |card|
        print "#{card} | "
      end
      puts ""
      print "-" * card_space * cards.size
    end
  end

  def display_other_cards
    @game.get_next_player_cards
  end
end

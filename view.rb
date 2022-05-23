class PrimesView
  def initialize(game)
    @game = game
  end

  def display_welcome
    puts ""
    puts "Welcome #{@game.get_current_player.get_name}"
    puts ""
    puts "Your level is #{@game.get_current_player.get_level_name}"
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
    puts @game.get_current_player.get_level_name
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

  def display_actions(action)
    return "" if action == ""
    if action[0].instance_of?(Integer)
      p "Add self to a new card, #{action[0]} + #{action[1]} = #{action[0] + action[1]}"
    elsif action[0] == "a"
      p "Add self average #{@game.get_current_player.get_cards_average} to your card #{action[1]}}"
    elsif action[0] == "s"
      p "Take other person's card #{action[1]} to your greatest card."
    else
      return ""
    end
  end
end

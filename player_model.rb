class Player
  def initialize(name, player_id)
    @name = name
    @player_id = player_id
    @cards = []
    @points = 0
  end

  def init_cards(card)
    @cards << card
  end

  def get_id
    return @player_id
  end

  def get_cards
    sort_cards
    return @cards
  end

  def get_cards_average
    if @cards.size > 0
      return @cards.sum / @cards.size
    else
      return 0
    end
  end

  def change_cards(new_cards)
    @cards = new_cards
  end

  def get_points
    return @cards.sum
  end

  def sort_cards
    @cards.sort!
  end
end

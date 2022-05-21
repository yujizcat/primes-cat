class Player
  def initialize(name, player_id, is_ai)
    @name = name
    @player_id = player_id
    @cards = []
    @original_cards = []
    @points = 0
    @powers = 0
    @average_round = 0
    @current_history = []
    @is_ai = is_ai
  end

  def get_id
    return @player_id
  end

  def get_name
    return @name
  end

  def init_cards(card)
    @cards << card
  end

  def set_original_card
    @original_cards = @cards.clone
  end

  def get_original_card
    @original_cards
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

  def append_to_history
    @current_history << @cards.sort
  end

  def get_current_history
    return @current_history
  end

  def get_uniqueness
    return @current_history.uniq.size
  end

  def get_uniqueness_rate(round)
    return ((@current_history.uniq.size * 1.0 / round).round(2) * 100).to_i
  end

  def set_init_powers
    @powers = (get_cards[-1] / 10) + get_cards.size
    return @powers
  end

  def get_powers
    return @powers
  end

  def reduce_powers
    @powers -= 1
    return @powers
  end

  def is_ai?
    @is_ai
  end
end
